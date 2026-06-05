//
//  UserDefault.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 05/06/26.
//

import Foundation
struct UDKeys
{
   
    static let fcmId = "fcmId"
   
    
}
struct MyUserDefaults {
    private let defaults = UserDefaults.standard
    private init(){}
    static var instance = MyUserDefaults()

    enum Key:String {
        case access_token,name,email,number,address,companyName,profilePicture,id,countryID
    }

    func set<T>(value:T,key:Key){
        defaults.set(value, forKey: key.rawValue)
    }
    
    func get<T>(key:Key) -> T?{
        return defaults.value(forKey: key.rawValue) as? T
    }
    
    static var fcmId: String? {
      get {
        return UserDefaults.standard.value(forKey: UDKeys.fcmId) as? String
      }
      set {
        if let value = newValue {
          UserDefaults.standard.set(value, forKey: UDKeys.fcmId)
        }
        else {
          UserDefaults.standard.removeObject(forKey: UDKeys.fcmId)
        }
      }
    }
    
}


