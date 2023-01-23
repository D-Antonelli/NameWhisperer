//
//  ContentView.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 16/01/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var users: [User] = []
    @State var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    NavigationLink {
                        user.image.view
                            .resizable()
                            .scaledToFit()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("\(user.name)")
                    } label: {
                        Text("\(user.name)")
                    }
                    
                }
                
            }
            .navigationTitle("Photos")
            .toolbar {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Pick photo")
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
                            users.append(User(name: "username", image: UserImage(data: data)))
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
