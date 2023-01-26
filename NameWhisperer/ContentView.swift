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
    
    // TODO: ENABLE IMAGE NAME EDIT
    
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
                viewModel.loadTransferable()
            }
            .onChange(of: viewModel.users) { newValue in
                guard let lastAdded = viewModel.users.popLast() else {
                    return
                }
                
                let lastAddedWithNameUpdate = User(name: "new name", photo: lastAdded.photo)
                
                viewModel.users.append(lastAddedWithNameUpdate)
                
            }
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

