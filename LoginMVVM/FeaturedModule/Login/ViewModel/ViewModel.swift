//
//  ViewModel.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 21/05/26.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject{
    func loginFailure(message: String)
    func loginSuccessful(message: String)
    func validateInputs(username: String, password: String) -> Bool
}

class LoginViewModel {
    weak var delegate: LoginViewModelProtocol?
    
    func loginRequest(username: String, password: String) {
        guard let delegate = delegate, delegate.validateInputs(username: username, password: password) else {
            return
        }
        
        AppEnvironmentSCStack.loginServiceController.loginRequest(username: username, password: password) { response in
            switch response {
            case .success(let data):
                print("\(LoginModel.self) response is :\(data)")
                if let message = data.message, message == "Invalid credentials" {
                    self.delegate?.loginFailure(message: message)
                } else {
                    if let userID = data.id, let accessToken = data.accessToken {
                        MyUserDefaults.instance.set(value: userID, key: MyUserDefaults.Key.id)
                        MyUserDefaults.instance.set(value: accessToken, key: MyUserDefaults.Key.access_token)
                        self.delegate?.loginSuccessful(message: "Login successful.")
                    } else {
                        self.delegate?.loginFailure(message: "User ID not found.")
                    }
                }
            case .failure(let error):
                print("Login API error: \(error.message ?? "Unknown error")")
                self.delegate?.loginFailure(message: error.message ?? "Unknown error")
            }
        }
    }
}
