//
//  LoginModel.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 21/05/26.
//

import Foundation


struct LoginModel{
    
    static func createRequestBody(username: String,password: String) -> LoginModel.Request {
        
        let requestBody = LoginModel.Request(username: username,password: password)
        return requestBody
    }
    // MARK: - Request
    struct Request: Codable {
        let username, password: String?
    }
    
    // MARK: - Response
    struct Response: Codable {
        let accessToken: String?
        let refreshToken: String?
        let id: Int?
        let username: String?
        let email: String?
        let firstName: String?
        let lastName: String?
        let gender: String?
        let image: String?
        let message: String?
    }
}
