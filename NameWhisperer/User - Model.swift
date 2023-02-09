//
//  User.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 19/01/2023.
//

import Foundation
import SwiftUI

struct User: Hashable, Equatable {
    var id = UUID()
    let name: String
    let jpegImage: Data
    
    var image: Image {
        guard let uiImage = UIImage(data: jpegImage) else { return <#default value#> }
        return Image(uiImage: uiImage)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case jpegImage
     }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(jpegImage, forKey: .jpegImage)
    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        var values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        jpegImage = try values.decode(Data.self, forKey: .jpegImage)
    }
}





