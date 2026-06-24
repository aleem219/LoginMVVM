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
 
 if let alert = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as? AlertView {
 alert.frame = self.view.bounds
 alert.configure(
     heading: "Are you sure you want to login?",
     subHeading: "You'll need to enter your credentials again next time."
 )
 alert.onLogoutTapped = {
 print("Logout from LoginVC")
 }
 
 alert.onCancelTapped = {
 print("Cancel from LoginVC")
 }
 self.view.addSubview(alert)
 }
 
 */
