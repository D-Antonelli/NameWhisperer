//
//  UserRepository.swift
//  NameWhisperer
//
//  Created by Derya Antonelli on 26/01/2023.
//

import Foundation

class UserRepository: UserRepositoryInterface {

    var list: [User]
    
    init(list: [User]) {
        self.list = list
    }
    
    func getAll() -> [User] {
        return self.list
    }
    
    func add(user: User) -> Void {
        self.list.append(user)
    }
    
    func update(at: Int, with: User) -> Void {
        return
    }
    
    func remove() -> Void {
        return
    }
    
    func removeLast() -> Void {
        return
    }
    
    
}
