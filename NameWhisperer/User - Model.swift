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
    let image: UserImage
}


struct UserImage: Hashable {
    let data: Data
    
    var view: Image {
        let uiImage = UIImage(data: data) ?? UIImage()
        return Image(uiImage: uiImage)
    }
}



