//
//  NavigationBarConfigurator.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 03/06/26.
//

import UIKit
import Foundation


struct NavigationBarConfigurator {
    
    static func configure(
        _ navBar: NavigationBar,
        title: String,
        showLeftButton: Bool = true,
        showRightFirst: Bool = false,
        showRightSecond: Bool = false
    ) {
        navBar.title = title
        navBar.isLeftButtonHidden = !showLeftButton
        navBar.isRightButtonHidden = !showRightFirst
        navBar.isRightSecondButtonHidden = !showRightSecond
    }
}
