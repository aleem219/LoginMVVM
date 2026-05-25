//
//  ServiceController.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
class ServiceController {
    
    func encodeRequestBody<T: Encodable>(requestObject: T, name: String) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(requestObject)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("\(name) Service Request: \(jsonString ?? "")")
            return jsonData
        } catch {
            print("error encoding request")
            return nil
        }
    }
}
