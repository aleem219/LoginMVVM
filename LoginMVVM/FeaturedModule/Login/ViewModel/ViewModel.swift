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
                    self.delegate?.loginSuccessful(message: "Login successful.")
                }
            case .failure(let error):
                print("Login API error: \(error.message ?? "Unknown error")")
                self.delegate?.loginFailure(message: error.message ?? "Unknown error")
            }
        }
    }
}
