//
//  DropletAwsClient.swift
//  Droplet
//
//  Created by Josh McArthur on 9/11/21.
//

import Foundation
import SotoS3


let AWS_REGION = SotoS3.Region.apsoutheast2;
let AWS_BUCKET = Bundle.main.infoDictionary!["AWS_BUCKET_NAME"] as! String
let AWS_ACCESS_KEY_ID = Bundle.main.infoDictionary!["AWS_ACCESS_KEY_ID"] as! String
let AWS_SECRET_ACCESS_KEY = Bundle.main.infoDictionary!["AWS_SECRET_ACCESS_KEY"] as! String
let AWS_PRESIGNED_OBJECT_EXPIRY = SotoS3.TimeAmount.hours(24 * 7)


let awsClient = AWSClient(
    credentialProvider: .static(accessKeyId: AWS_ACCESS_KEY_ID, secretAccessKey: AWS_SECRET_ACCESS_KEY),
    httpClientProvider: .createNew
)

let s3 = S3(client: awsClient, region: AWS_REGION);
