//
//  UserListRepositoryInterface.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 26/01/2023.
//

import Foundation

protocol UserRepositoryInterface {
    var list: [User] { get set }
    func getAll() -> [User]
    func add(user: User)
    func update(at: Int, with: User)
    func remove()
    func removeLast()
}
