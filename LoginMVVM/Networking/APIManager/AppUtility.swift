//
//  AppUtility.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 21/05/26.
//

import Foundation

let kSharedInstance = AppUtility.shared

class AppUtility: NSObject {
    static let shared = AppUtility()

    func getDictionary(_ data: Data) -> [String: Any] {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
              let dict = json as? [String: Any] else {
            return [:]
        }
        return dict
    }
}


extension String {
    static func getString(_ value: Any?) -> String {
        return value as? String ?? ""
    }
}
