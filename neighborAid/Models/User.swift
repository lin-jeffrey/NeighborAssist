//
//  User.swift
//  neighborAid
//
//  Created by Jeffrey Lin on 7/20/21.
//

import Foundation

//struct for Requests
struct User{
    var aboutMe: String = ""
    var accountType: String = ""
    var email: String = ""
    var name: String = ""
    var uid: String = ""
    
    init(aboutMe: String, accountType: String, email: String, name: String, uid: String) {
        self.aboutMe = aboutMe
        self.accountType = accountType
        self.email = email
        self.name = name
        self.uid = uid
    }
}
