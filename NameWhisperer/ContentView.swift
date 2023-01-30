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
            
        }
        .alert("Rename", isPresented: $viewModel.showRenameScreen) {
            TextField(text: $viewModel.newName) {
                Text("Enter a name")
            }
            Button("OK") {
                viewModel.setNewName()
            }
            
        }  
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

