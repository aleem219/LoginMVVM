//
//  UserDetailsVC.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 05/06/26.
//

import UIKit

class UserDetailsVC: UIViewController {
    @IBOutlet weak var navBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // MARK: - Setup
    private func setupNavBar() {
        NavigationBarConfigurator.configure(
            navBar,
            title: "User Details"
        )
    }

}

/*
 
 // - For fure refrence - //
 
 AlertView.show(
     in: self.view,
     heading: "Are you sure you want to login?",
     subHeading: "You saved your credentials, so logging back in will be easy.\nYou can change that setting from the login screen.",
     onLogout: {
         print("Logout from LoginVC")
     },
     onCancel: {
         print("Cancel from LoginVC")
     }
 )
 
 */
