//
//  User.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 19/01/2023.
//

import Foundation
import SwiftUI

struct User: Hashable {
    let id = UUID()
    let name: String
    let uiImage: UIImage
    
    var imageView: Image {
        return Image(uiImage: uiImage)
    }
}
