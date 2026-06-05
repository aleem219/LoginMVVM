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
