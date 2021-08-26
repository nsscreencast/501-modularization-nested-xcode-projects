//
//  ContentView.swift
//  StyleguideDemo
//
//  Created by Ben Scheirman on 8/18/21.
//

import SwiftUI
import Styleguide

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(UIColor.brandPrimary)
            Text("Hello, world!")
                .foregroundColor(.white)
                .padding()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
