//
//  Content View - View Model.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 23/01/2023.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var users: [User] = []
    }
}
