//
//  UserViewModel.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/05/26.
//

import Foundation


protocol UserViewModelProtocol: AnyObject{
    func userFailure(message: String)
    func didFetchUsers(_ users: [User])
}

class UserViewModel {
    weak var delegate: UserViewModelProtocol?
    
    // MARK: - Pagination State
    private let pageLimit = 10
    private var currentSkip = 0
    private var totalUsers = 0
    private(set) var allUsers: [User] = []
    var isFetching = false
    
    var hasMoreUsers: Bool {
        return allUsers.count < totalUsers
    }
    
    // MARK: - Fetch Users (Initial Load)
    func fetchUsers() {
        currentSkip = 0
        allUsers = []
        loadUsers()
    }
    
    // MARK: - Fetch Next Page
    func fetchNextPageIfNeeded() {
        guard !isFetching, hasMoreUsers else { return }
        loadUsers()
    }
    
    // MARK: - Core Load
    private func loadUsers() {
        isFetching = true
        
        AppEnvironmentSCStack.userServiceController.getUsersRequest(
            skip: currentSkip,
            limit: pageLimit
        ) { response in
            DispatchQueue.main.async {
                self.isFetching = false
                
                switch response {
                case .success(let data):
                    let newUsers = data.users ?? []
                    self.totalUsers = data.total ?? 0
                    self.currentSkip += newUsers.count
                    self.allUsers.append(contentsOf: newUsers)
                    let token: String? = MyUserDefaults.instance.get(key: .access_token)
                    print("Access token is: \(token ?? "")")
                    print("Fetched \(newUsers.count) users | Total loaded: \(self.allUsers.count)/\(self.totalUsers)")
                    self.delegate?.didFetchUsers(self.allUsers)
                    
                case .failure(let error):
                    print("Fetch Users API error: \(error.message ?? "Unknown error")")
                    self.delegate?.userFailure(message: error.message ?? "Unknown error")
                }
            }
        }
    }
    
    // MARK: - Save User Images Locally
    func saveAllUserImages(from users: [User]) {
        users.forEach { user in
            guard let imageUrl = user.image,
                  let imageName = user.username else { return }
            
            AppEnvironmentSCStack.userServiceController.saveUserImage(
                imageUrl: imageUrl,
                imageName: imageName,
                folderName: "UserProfiles"
            )
        }
    }
}
