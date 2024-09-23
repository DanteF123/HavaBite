//
//  User.swift
//  HavaBite
//
//  Created by Dante Fusaro on 9/14/24.
//

import Foundation

struct User{
    let first_name: String
    let last_name: String
    let email : String
    let id : String
    
    init(first_name: String, last_name: String, email: String, id: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.id = id
    }
}
