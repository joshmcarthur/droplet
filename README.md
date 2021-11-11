
<p align="center">
  <img width="128" height="128" src="https://github.com/joshmcarthur/droplet/raw/main/images/icon_128x128%402x.png" alt="Droplet icon">
  <h1 align="center">Droplet</h1>
</p>

![Demo](demo.gif)

Droplet is a very small SwiftUI application that runs in the menubar and allows
a file to be dropped onto the popover. When a file is dropped, it will be
uploaded to an S3 bucket that you configure, a presigned URL generated and
copied to your clipboard.


### How to build

Copy Config.example.xconfig to Config.xconfig and fill in the values. At the
moment, an access keypair is the only way to authenticate, and there is no
settings interface yet for these values.

Open the project and build. It should be good to go from there.

### What is working

* Dropping files into the popover
* Uploading to S3 with the correct content type and disposition for inline viewing
* Generating a presigned URL
* Copying the presigned URL automatically to the clipboard

### What is planned

* A settings UI for specifying access key ID, secret access key, region and
  bucket, and default expiration time.
* An actual UI for uploading files
* 'Click to copy' presigned URL display
* Ability to reset the upload
* Ability to specify a custom expiration time

