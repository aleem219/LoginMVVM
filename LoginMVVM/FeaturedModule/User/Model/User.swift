//
//  User.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/05/26.
//

import Foundation

struct User: Codable {
    var id: Int
    var firstName: String?
    var lastName: String?
    var maidenName: String?
    var email: String?
    var phone: String?
    var username: String?
    var image:String?
    var address : Address
   
}

struct Address: Codable{
    var address: String?
}

struct UserResponse: Codable {
    var users: [User]?
    var total: Int?
    var skip: Int?
    var limit: Int?
}
