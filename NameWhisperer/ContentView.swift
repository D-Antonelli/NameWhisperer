//
//  ContentView.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 16/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                // items here
            }
            .navigationTitle("Photos")
            .toolbar {
                Button {
                    // import
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
                
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
