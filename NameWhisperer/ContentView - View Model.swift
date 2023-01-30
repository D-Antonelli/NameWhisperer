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
        @Published private(set) var users: [User] = []
        @Published var selectedItem: PhotosPickerItem? = nil {
            didSet {
                Task { @MainActor in
                    loadTransferable()
                }
            }
        }
        @Published var showRenameScreen = false
        @Published var newName: String = "Unknown"
        
        private var data: Data = Data()
        
        public func setNewName() -> Void {
            self.users.append(User(name: self.newName, photo: UserImage(data: self.data)))
        }
        
        private func loadTransferable() -> Void {
            DispatchQueue.main.async {
                guard let imageSelection = self.selectedItem else { return }
                
                imageSelection.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            Task { @MainActor in
                                self.showRenameScreen = true
                                self.data = data
                            }
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
