//
//  DropletApp.swift
//  Droplet
//
//  Created by Josh McArthur on 9/11/21.
//

import SwiftUI
import Cocoa
import AppKit

@main
struct DropletApp: App {
    @NSApplicationDelegateAdaptor(DropletAppDelegate.self) var delegate;
    var body: some Scene {
        Settings {
          EmptyView()
        }
    }
}
