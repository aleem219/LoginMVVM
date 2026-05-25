//
//  ErrorResponseModel.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation

public struct ErrorResponseModel: Decodable {
    var code: String?
    var message: String?
    enum CodingKeys: String, CodingKey {
        case code = "errorCode"
        case message = "errorMessage"
    }

    enum RootKeys: String, CodingKey {
        case error
    }

    init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        if let errorContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error) {
            self.code = try errorContainer.decode(String?.self, forKey: .code)
            self.message = try errorContainer.decode(String?.self, forKey: .message)
        }
    }
}
