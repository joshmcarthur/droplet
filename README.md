
<p align="center">
  <img width="128" height="128" src="https://github.com/joshmcarthur/droplet/raw/main/images/icon_128x128%402x.png" alt="Droplet icon">
  <h1 align="center">Droplet</h1>
</p>

![Demo](demo.gif)

Droplet is a very small SwiftUI application that runs in the menubar and allows
a file to be dropped onto the popover. When a file is dropped, it will be
uploaded to an S3 bucket that you configure, a presigned URL generated and
copied to your clipboard.

### What is working

* Dropping files into the popover
* Uploading to S3 with the correct content type and disposition for inline viewing
* Generating a presigned URL
* Copying the presigned URL automatically to the clipboard
* A settings UI for specifying access key ID, secret access key, region and
  bucket, and default expiration time.
* An UI for uploading files
* 'Click to copy' presigned URL display
* Ability to reset the upload
* Ability to specify a custom expiration time

### What is planned

* Show a location notification when the file has been uploaded


