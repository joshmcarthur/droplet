//
//  SettingsView.swift
//  Droplet
//
//  Created by Josh McArthur on 12/11/21.
//

import Foundation
import SwiftUI
import SotoS3

enum ObjectExpiryOptions: Int, Identifiable, CaseIterable {
    case one_hour = 1
    case four_hours = 4
    case twelve_hours = 12
    case one_day = 24
    case two_days = 48
    case five_days = 120
    case seven_days = 168
    
    var id: String { self.rawValue < 24 ? self.rawValue.formatted() + " hours" : (self.rawValue / 24).formatted() + " days"}
}

struct SettingsView : View {
    @AppStorage("awsAccessKeyId") private var awsAccessKeyId = ""
    @AppStorage("awsSecretAccessKey") private var awsSecretAccessKey = ""
    @AppStorage("awsBucketName") private var awsBucketName = ""
    @AppStorage("awsRegion") private var awsRegion = "us-west-1"
    @AppStorage("awsDefaultObjectExpiry") private var awsDefaultObjectExpiry = ObjectExpiryOptions.one_day
    
    @State private var showValidationAlert = false
    
   
    var body : some View {
        Form {
            TextField("AWS Access Key ID", text: $awsAccessKeyId)
            SecureField("AWS Secret Access Key", text: $awsSecretAccessKey).redacted(reason: .privacy).textSelection(.disabled)
            TextField("AWS Region", text: $awsRegion)
            TextField("Bucket name", text: $awsBucketName)
            Picker("Default object expiry", selection: $awsDefaultObjectExpiry) {
                ForEach(ObjectExpiryOptions.allCases, id: \.self) { expiryOption in Text(expiryOption.id).tag(expiryOption.id) }
            }
            
            Button("Done", action: {
                showValidationAlert = awsAccessKeyId.isEmpty || awsBucketName.isEmpty || awsSecretAccessKey.isEmpty || awsRegion.isEmpty;
                
                if (!showValidationAlert) {
                    NSApp.sendAction(#selector(DropletAppDelegate.hideSettings), to: nil, from:nil)
                }
                   })
            .padding()
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Please enter AWS access key ID, secret access key, bucket name and region"), dismissButton: .default(Text("OK")))
            }.padding()
        }.padding().frame(width: 500, height: 300, alignment: .center)
}
}
