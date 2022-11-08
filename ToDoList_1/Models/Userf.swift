//
//  User.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 7.11.2022.
//

import Foundation
import Firebase

struct Userf {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
