//
//  User.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/14/24.
//

import Foundation

struct User{
    let name: String
    let email : String
    let id : String
    
    init(name: String,email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
    }
}
