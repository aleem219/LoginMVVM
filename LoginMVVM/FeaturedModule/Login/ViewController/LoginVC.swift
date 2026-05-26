//
//  ViewController.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 07/05/26.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnRenoveImg: UIButton!
    
    // MARK: - variables
    let viewModel = LoginViewModel()
    var imagePicker: ImagePicker!
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        btnRenoveImg.isHidden = true
        btnRenoveImg.layer.cornerRadius = btnRenoveImg.frame.width / 2
        imgView.layer.cornerRadius = imgView.frame.width / 2
        btnUpload.layer.cornerRadius = btnUpload.frame.width / 2
    }
    
    // MARK: - Button's Action
    @IBAction func btnLoginAction(_ sender: UIButton) {
        guard let username = userNameTF.text, let password = passwordTF.text else { return }
        if !validateInputs(username: username, password: password) {
            return
        }
        viewModel.loginRequest(username: username, password: password)
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func btnRenoveImgAction(_ sender: UIButton) {
        imgView.image = nil
        btnUpload.isHidden = false
        btnRenoveImg.isHidden = true
    }
    
    @IBAction func btnEyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.fill" : "eye.slash.fill"), for: .normal)
    }
}

// MARK: - LoginViewModelProtocol
extension LoginVC: LoginViewModelProtocol {
    
    func validateInputs(username: String, password: String) -> Bool {
        guard !username.isEmpty else { showAlert(message: StringConstants.Login.userName); return false }
        guard !password.isEmpty else { showAlert(message: StringConstants.Login.password); return false }
        return true
    }
    
    func loginSuccessful(message: String) {
        showAlert(message: message) {
            let vc = AppStoryboard.userStoryboard.instantiateViewController(identifier: StringConstants.StoryBoard.userVC) as! UserVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loginFailure(message: String) {
        showAlert(message: message) {}
        UIViewController.getTopViewController()?.LoadingStop()
    }
}

// MARK: - ImagePickerDelegate
extension LoginVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let size = Double(imgData.count) / 1048576
        if size > 10.00 {
            showAlert(message: StringConstants.AlertMessage.maxUploadSize)
        } else {
            imgView.image = image
            btnUpload.isHidden = true
            btnRenoveImg.isHidden = false
        }
    }
}

