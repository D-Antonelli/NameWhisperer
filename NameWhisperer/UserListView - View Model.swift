//
//  Content View - View Model.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 23/01/2023.
//

import Foundation
import PhotosUI
import SwiftUI

extension UserListView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var users: [User] = []
        @Published private(set) var imageState: ImageState = .empty
        
        @Published var imageSelection: PhotosPickerItem? = nil {
            didSet {
                if let imageSelection {
                    let progress = loadTransferable(from: imageSelection)
                    imageState = .loading(progress)
                } else {
                    imageState = .empty
                }
            }
        }
        
        @Published public var newName: String = "Unknown"
        @Published public var showRenamePrompt = false
        
        private var image: Image?
        
        
        enum ImageState {
            case empty
            case loading(Progress)
            case success
            case failure(Error)
        }
        
        enum TransferError: Error {
            case importFailed
        }
        
        
        struct UserImage: Transferable {
            let image: Image
            
            static var transferRepresentation: some TransferRepresentation {
                DataRepresentation(importedContentType: .image) { data in
                    guard let uiImage = UIImage(data: data) else {
                        throw TransferError.importFailed
                    }
                    let image = Image(uiImage: uiImage)
                    return UserImage(image: image)
                }
            }
            
        }
        
        
        public func save() -> Void {
            self.users.append(User(name: self.newName, image: self.image!))
        }
        
        
        private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
            return imageSelection.loadTransferable(type: UserImage.self) { result in
                DispatchQueue.main.async {
                    guard imageSelection == self.imageSelection else {
                        print("Failed to get the selected item.")
                        return
                    }
                }
                
                switch result {
                case .success(let userImage?):
                    Task { @MainActor in
                        self.imageState = .success
                        self.image = userImage.image
                        self.showRenamePrompt = true
                    }
                    
                case .success(nil):
                    self.imageState = .empty
                    
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
