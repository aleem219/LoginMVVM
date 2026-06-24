//
//  AlertView.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 24/06/26.
//

import UIKit

class AlertView: UIView {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    
    // -  Closures so each screen can define its own action
    var onLogoutTapped: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        if let hitView = self.hitTest(touchPoint, with: nil), hitView == self {
            self.removeFromSuperview()
        }
    }
    
    // -  Configure text dynamically
      func configure(heading: String, subHeading: String) {
          lblHeading.text = heading
          lblSubHeading.text = subHeading
      }
    
    
    
    @IBAction func btnLogoutAction(_ sender: DesignableButton) {
        onLogoutTapped?()
    }
    
    @IBAction func btnCancelAction(_ sender: DesignableButton) {
        self.removeFromSuperview()
        onCancelTapped?()
    }
    
}
