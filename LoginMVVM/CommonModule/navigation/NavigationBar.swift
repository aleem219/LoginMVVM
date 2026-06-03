//
//  NavigationBar.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 20/05/26.
//


import Foundation
import UIKit

final class NavigationBar: UIView {
    
    private static let NIB_NAME = "NavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightFirstButton: UIButton!
    @IBOutlet private weak var rightSecondButton: UIButton!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isLeftButtonHidden: Bool {
        set {
            leftButton.isHidden = newValue
        }
        get {
            return leftButton.isHidden
        }
    }
    
    var isRightButtonHidden: Bool {
        set {
            rightFirstButton.isHidden = newValue
        }
        get {
            return rightFirstButton.isHidden
        }
    }
    
    var isRightSecondButtonHidden: Bool {
        set {
            rightSecondButton.isHidden = newValue
        }
        get {
            return rightSecondButton.isHidden
        }
    }
    
    var isRightFirstButtonEnabled: Bool {
        set {
            rightFirstButton.isEnabled = newValue
        }
        get {
            return rightFirstButton.isEnabled
        }
    }
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(NavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        var responder: UIResponder? = self
          while let next = responder?.next {
              responder = next
              if let viewController = responder as? UIViewController {
                  if viewController.navigationController != nil {
                      viewController.popUp()
                  } else {
                      viewController.dismiss(animated: true)
                  }
                  break
              }
          }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
}
