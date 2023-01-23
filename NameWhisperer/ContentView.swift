//
//  ContentView.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 16/01/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink {
                        user.photo.view
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
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                    Text("Pick photo")
                }
            }
            .onChange(of: viewModel.selectedItem) { newValue in
                guard let item = viewModel.selectedItem else {
                    return
                }
                
                item.loadTransferable(type: Data.self) {
                    result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            viewModel.users.append(User(name: "New user", photo: UserImage(data: data)))
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

