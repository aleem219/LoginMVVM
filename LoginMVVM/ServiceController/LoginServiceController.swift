//
//  LoginServiceController.swift
//
//  LoginServiceController.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
import UIKit
import ProgressHUD

protocol LoginServiceControllerProtocol {
    func loginRequest(username: String, password: String,_ completion: @escaping (_ response: ServiceOutcome<LoginModel.Response>) -> Void)
}

class LoginServiceController: ServiceController, LoginServiceControllerProtocol {
    
    var callBack: ((ServiceOutcome<LoginModel.Response>) -> Void)?
    
    func loginRequest(username: String, password: String,
                      _ completion: @escaping (ServiceOutcome<LoginModel.Response>) -> Void) {

        let requestBody = createBody(username: username, password: password) ?? Data()
        let serviceUrl = StringConstants.URLConstants.login

        AppsNetworkManager.sharedInstanse.requestApi(
            requestData: requestBody,
            serviceurl: serviceUrl,
            methodType: .post
        ) { data in

            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }

            do {
                if let rawJson = String(data: data, encoding: .utf8) {
                    print("Raw LoginModel Json is: \(rawJson)")
                }

                let response = try JSONDecoder().decode(LoginModel.Response.self, from: data)
                completion(.success(response))

            } catch {
                if let errorObj = try? JSONDecoder().decode(ErrorResponseModel.self, from: data) {
                    completion(.failure(errorObj))
                } else {
                    let errorObj = ErrorResponseModel(
                        code: nil,
                        message: StringConstants.Message.jsonDecodingError
                    )
                    completion(.failure(errorObj))
                }
            }
        }
    }


    
    private func createBody(username: String, password: String) -> Data? {
        let requestBody = LoginModel.createRequestBody(username: username, password: password)
        return encodeRequestBody(requestObject: requestBody, name: "\(LoginModel.self)")
    }
}
