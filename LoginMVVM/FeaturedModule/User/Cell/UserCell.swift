//
//  UserCell.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/05/26.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserPhone: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUser.layer.cornerRadius = imgUser.frame.width / 2
        mainView.layer.cornerRadius = 12
        imgUser.layer.borderWidth = 1
        imgUser.layer.borderColor = UIColor(red: 240/255, green: 247/255, blue: 240/255, alpha: 1).cgColor
    }
    
    func configure(with user: User) {
        lblUserName.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        lblUserEmail.text = user.email ?? "-"
        lblUserPhone.text = "phone: \(user.phone ?? "-")"
        
        if let imageUrl = user.image {
            imgUser.downlodeImage(serviceurl: imageUrl)
        }
    }
}
