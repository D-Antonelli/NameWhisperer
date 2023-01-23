//
//  Content View - View Model.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 23/01/2023.
//

import Foundation
import PhotosUI
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var users: [User] = []
        @Published var selectedItem: PhotosPickerItem?
        
        func loadTransferable() -> Void {
            guard let imageSelection = self.selectedItem else { return }
            
            imageSelection.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self.users.append(User(name: "New user", photo: UserImage(data: data)))
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
