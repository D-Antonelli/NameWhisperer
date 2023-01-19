//
//  ContentView.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 16/01/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var selectedItem: PhotosPickerItem?
    @State var data: Data?
    
    var body: some View {
        NavigationView {
            List {
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .navigationTitle("Photos")
            .toolbar {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Pick photo")
                }
            }
            
        }
        .onChange(of: selectedItem) { newValue in
            guard let item = selectedItem else {
                return
            }
            
            item.loadTransferable(type: Data.self) {
                result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.data = data
                    } else {
                        print("data is nil")
                    }
                    
                case .failure(let failure):
                    fatalError("\(failure)")
                
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
