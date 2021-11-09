//
//  ContentView.swift
//  Droplet
//
//  Created by Josh McArthur on 9/11/21.
//

import SwiftUI

struct DroppableArea: View {
    @State private var fileUrl: URL?
    @State private var signedUrl: URL?
    @State private var active = false
    

    var body: some View {
        
        let dropDelegate = DropletDropDelegate(fileUrl: $fileUrl, signedUrl: $signedUrl, active: $active)
        
        Text(self.signedUrl != nil ? self.signedUrl!.absoluteString : "Hello, world!")
            .background(self.active ? .red : .teal)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onDrop(of: ["public.file-url"], delegate: dropDelegate)
    }
}

struct ContentView: View {
    var body = DroppableArea()

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
