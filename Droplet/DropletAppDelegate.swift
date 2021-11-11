import Cocoa
import AppKit
import SwiftUI

class DropletAppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var settingsWindow: NSWindow!    // << here

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
                
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "MenubarIcon")
            button.action = #selector(togglePopover(_:))
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
    @objc func hideSettings() {
        let contentView = ContentView()
        self.popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover.contentViewController?.view.window?.becomeKey()
    }
    

   @objc func showSettings() {
       let settingsView = SettingsView()
       self.popover.contentViewController = NSHostingController(rootView: settingsView)
       self.popover.contentViewController?.view.window?.becomeKey()
   }

    
}
