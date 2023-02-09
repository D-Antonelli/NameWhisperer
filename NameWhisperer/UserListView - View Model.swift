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
        @Published public var showImagePicker = false
        
        private let savePath = FileManager.documentsDirectory.appendingPathComponent("users.txt")
        private var users: [User] = []
        
        private var jpegImage: Data?
        
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
            let jpeg: Data?
            
            static var transferRepresentation: some TransferRepresentation {
                DataRepresentation(importedContentType: .image) { data in
                    guard let uiImage = UIImage(data: data) else {
                        throw TransferError.importFailed
                    }
                    let data = uiImage.jpegData(compressionQuality: 0.8)
                    return UserImage(jpeg: data)
                }
            }
            
        }
        
        public func onViewAppear() {
            // list = loadUsers()
            // load users from device. If list is empty,
            viewModelState = .empty
            
            // if there are items in list,
            // viewModelState = .hasUsers(list)
        }
    
        public func save() -> Void {
            switch self.viewModelState {
            case .hasUsers(let currentUsers):
                users.append(contentsOf: currentUsers)
                print("\(users)");
            default:
                break
            }
            if let jpegImage = self.jpegImage {
                users.append(User(name: self.newName, jpegImage: jpegImage))
                self.viewModelState = .hasUsers(users)
            } else {
                self.viewModelState = .failure
            }
        }
        
        private func saveToDirectory() {
            // TODO: Convert users into json
            do {
                let data = try JSONEncoder().encode(users)
//                json = String(data: data, encoding: .utf8)
                
                // then, save
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("\(error)")
            }
            
        }
        
        public func pickImage() -> Void {
            self.viewModelState = .pickingImage
            self.showImagePicker = true
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
                        self.jpegImage = userImage.jpeg
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
