//
//  ImagePicker.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 20/02/2023.
//

import PhotosUI
import SwiftUI

struct CameraImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var isPresented
    

    func makeUIViewController(context: Context) -> UIImagePickerController {
        // fallback?
        // guard UIImagePickerController.isSourceTypeAvailable(.camera) else {  }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        
        // Displays a control that allows the user to choose picture or
        // movie capture, if both are available:
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use true.
        imagePicker.allowsEditing = false
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.parent.image = selectedImage
            self.parent.isPresented.wrappedValue.dismiss()
        }
    }
}
