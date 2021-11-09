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
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.file-url"])
    }
    
    func dropEntered(info: DropInfo) {
        self.active = true
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: ["public.file-url"]).first {
                        item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                            DispatchQueue.main.async {
                                if let urlData = urlData as? Data {
                                    self.fileUrl = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                    let request = S3.CreateMultipartUploadRequest(bucket: AWS_BUCKET,
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
                                        print(progress)
                                    }
                                    
                                    multipartUploadRequest.whenFailure { error in
                                        print(error)
                                    }
                                    
                                    multipartUploadRequest.whenSuccess { output in
                                        DispatchQueue.main.async {
                                            let location = output.location!
                                        
                                            do {
                                                self.signedUrl = try s3.signURL(
                                                    url: URL(string: location)!,
                                                    httpMethod: .GET,
                                                    expires: AWS_PRESIGNED_OBJECT_EXPIRY
                                                ).wait()
                                                let pasteboard = NSPasteboard.general
                                                pasteboard.clearContents()
                                                pasteboard.setString(self.signedUrl!.absoluteString, forType: .string)
                                            }
                                            catch {
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
}

