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
        @Published private(set) var imageState: ImageState = .empty
        @Published private(set) var viewModelState: ViewModelState = .loading
        
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
        
        private var users: [User] = []
        private var image: Image?
        
        enum ViewModelState {
            case loading
            case failure
            case empty
            case hasUsers([User])
            case pickingImage
            case namingImage(Bool)
        }
        
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
        
        public func onViewAppear() {
            viewModelState = .empty
        }
    
        public func save() -> Void {
            switch self.viewModelState {
            case .hasUsers(let currentUsers):
                users.append(contentsOf: currentUsers)
            default:
                break
            }
            users.append(User(name: self.newName, image: self.image!))
            self.viewModelState = .hasUsers(users)
        }
        
        public func pickImage() -> Void {
            self.viewModelState = .pickingImage
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
                        self.viewModelState = .namingImage(true)
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
