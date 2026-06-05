//
//  Constant.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 21/05/26.
//

import UIKit
import Foundation


let appDelegate = UIApplication.shared.delegate as! AppDelegate

public enum StringConstants {
    public enum URLConstants {
        static let login = "\(AppsNetworkManagerConstants.baseUrl)/login"
        static let users = "\(AppsNetworkManagerConstants.baseUrl)/users"
    }
    
    public enum Regex {
        static let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    }
    
    public enum Common {
        static let no = "No"
        static let yes = "Yes"
        static let done = "Done"
        static let okay = "Okay"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
        static let format = "SELF MATCHES %@"
    }
    
    public enum Message {
        static let invalidURL = "Invalid URL"
        static let unknownError = "Unknown Error"
        static let jsonDecodingError = "JSON Decoding Error"
        static let memberAdded = "Member added successfully"
        static let commonError = "App is currently processing your previous request, please wait for some time."
    }
    
    public enum Login {
        static let userName = "Please enter username"
        static let password = "Please enter password"
        static let strongPassword = "Password must be atleast 6 characters!"
        static let validCredential = "Please enter valid email or mobile number"
    }
    
    public enum AlertMessage {
        static let knoNetwork = "No Internet Available"
        static let maxUploadSize = "Maximum upload file size: 10MB"
        static let networkAvailablity = "Please check your internet connection and try again."
    }
    
    public enum StoryBoard {
        static let userVC = "UserVC"
        static let loginVC = "LoginVC"
    }
    
    public enum Cells {
        static let UserCell = "UserCell"
    }
}

public enum ServiceOutcome<T> {
    case success(T)
    case failure(ErrorResponseModel)
}
