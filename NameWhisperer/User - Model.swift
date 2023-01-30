//
//  User.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 19/01/2023.
//

import Foundation
import SwiftUI

struct User: Hashable, Equatable {
    let id = UUID()
    let name: String
    let image: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}




