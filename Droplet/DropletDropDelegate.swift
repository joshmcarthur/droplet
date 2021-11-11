//
//  DropletDropDelegate.swift
//  Droplet
//
//  Created by Josh McArthur on 9/11/21.
//

import SwiftUI
import SotoS3
import AVFoundation

struct DropletDropDelegate : DropDelegate {
    @AppStorage("awsAccessKeyId") var awsAccessKeyId = ""
    @AppStorage("awsSecretAccessKey") var awsSecretAccessKey = ""
    @AppStorage("awsRegion") var awsRegion = "";
    @AppStorage("awsBucketName") var awsBucketName = ""
    @AppStorage("awsDefaultObjectExpiry") var awsDefaultObjectExpiry = ObjectExpiryOptions.one_day
    
    
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.file-url"])
    }
    
    
    func performDrop(info: DropInfo) -> Bool {
        let awsClient = AWSClient(
            credentialProvider: .static(accessKeyId: awsAccessKeyId, secretAccessKey: awsSecretAccessKey),
            httpClientProvider: .createNew
        )
        let s3 = S3(client: awsClient, region: SotoS3.Region.init(rawValue: awsRegion));
        if let item = info.itemProviders(for: ["public.file-url"]).first {
                        item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                            DispatchQueue.main.async {
                                if let urlData = urlData as? Data {
                                    self.active = true
                                    self.fileUrl = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                    let request = S3.CreateMultipartUploadRequest(bucket: awsBucketName,
                                                                                  contentDisposition: "inline",
                                                                                  contentType: self.fileUrl!.mimeType(),
                                                                                  key: NSUUID().uuidString)
                                    let multipartUploadRequest = s3.multipartUpload(
                                        request,
                                        partSize: 5*1024*1024,
                                        filename: self.fileUrl!.path,
                                        abortOnFail: true,
                                        on: nil,
                                        threadPoolProvider: .createNew
                                    ) { progress in
                                        self.uploadProgress = progress
                                    }
                                    
                                    multipartUploadRequest.whenFailure { error in
                                        self.active = false;
                                        print(error)

                                        DispatchQueue.main.async {
                                            NSApplication.shared.presentError(error)
                                        }
                                        try! awsClient.syncShutdown()

                                    }
                                    
                                    multipartUploadRequest.whenSuccess { output in
                                        DispatchQueue.main.async {
                                            let location = output.location!
                                        
                                            do {
                                                self.signedUrl = try s3.signURL(
                                                    url: URL(string: location)!,
                                                    httpMethod: .GET,
                                                    expires: SotoS3.TimeAmount.hours(Int64(awsDefaultObjectExpiry.rawValue))
                                                ).wait()
                                                
                                                let pasteboard = NSPasteboard.general
                                                pasteboard.clearContents()
                                                pasteboard.setString(self.signedUrl!.absoluteString, forType: .string)
                                                try! awsClient.syncShutdown()
                                                self.active = false
                                            }
                                            catch {
                                                NSApplication.shared.presentError(error)
                                                print("Could not generated presigned URL for \(location)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        return true
                        
                    } else {
                        return false
                    }
        
    }
    
    @Binding var fileUrl: URL?
    @Binding var signedUrl: URL?
    @Binding var active: Bool
    @Binding var uploadProgress: Double
}

