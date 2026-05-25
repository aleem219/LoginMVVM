//
//  AppEnvironmentSCStack.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation

struct AppEnvironmentSCStack {
    static let loginServiceController: LoginServiceControllerProtocol = LoginServiceController()
    static let userServiceController: UserServiceControllerProtocol = UserServiceController()
}
