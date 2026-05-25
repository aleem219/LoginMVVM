//
//  UserServiceController.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/05/26.
//

import Foundation
import ProgressHUD


protocol UserServiceControllerProtocol {
    func getUsersRequest(skip: Int, limit: Int, _ completion: @escaping (_ response: ServiceOutcome<UserResponse>) -> Void)
    func saveUserImage(imageUrl: String, imageName: String, folderName: String)
}

class UserServiceController: ServiceController, UserServiceControllerProtocol {

    var callBack: ((ServiceOutcome<UserResponse>) -> Void)?

    func getUsersRequest(skip: Int, limit: Int, _ completion: @escaping (_ response: ServiceOutcome<UserResponse>) -> Void) {

        let serviceUrl = "\(StringConstants.URLConstants.users)?limit=\(limit)&skip=\(skip)"

        AppsNetworkManager.sharedInstanse.requestApi(
            requestData: Data(),
            serviceurl: serviceUrl,
            methodType: .get
        ) { data in

            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }

            do {
                if let rawJson = String(data: data, encoding: .utf8) {
                    print("Raw UserResponse Json is: \(rawJson)")
                }
                let response = try JSONDecoder().decode(UserResponse.self, from: data)
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
    
    // MARK: - Save User Image Locally
        func saveUserImage(imageUrl: String, imageName: String, folderName: String) {
            AppsNetworkManager.sharedInstanse.saveImageFromURL(
                imageUrl: imageUrl,
                imageName: imageName,
                folderName: folderName
            )
        }
}
