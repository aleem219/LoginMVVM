//
//  AppStoryboard.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/05/26.
//

import UIKit
import Foundation

struct AppStoryboard {
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name:"Main", bundle: Bundle.main)
    }
    
    static var userStoryboard: UIStoryboard {
        return UIStoryboard(name:"User", bundle: Bundle.main)
    }
}
