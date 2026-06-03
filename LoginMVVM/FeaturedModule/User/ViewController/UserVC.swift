//
//  UserVC.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 22/05/26.
//

import UIKit

class UserVC: UIViewController {
    @IBOutlet weak var navBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupViewModel()
        viewModel.fetchUsers()
    }
    
    // MARK: - Setup
    private func setupNavBar() {
        NavigationBarConfigurator.configure(
            navBar,
            title: "User List"
        )
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: StringConstants.Cells.UserCell, bundle: nil), forCellReuseIdentifier: StringConstants.Cells.UserCell)
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
}

extension UserVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.Cells.UserCell) as! UserCell
        cell.selectionStyle = .none
        cell.configure(with: viewModel.allUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.allUsers.count - 1 {
            viewModel.fetchNextPageIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UserVC: UserViewModelProtocol {
    
    func didFetchUsers(_ users: [User]) {
        tableView.reloadData()
    }
    
    func userFailure(message: String) {
        showAlert(message: message)
    }
}
