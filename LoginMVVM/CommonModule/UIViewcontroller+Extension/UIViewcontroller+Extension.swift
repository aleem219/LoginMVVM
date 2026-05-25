//
//  UIViewcontroller+Extension.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func showToast(message: String, in viewController: UIViewController) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let padding: CGFloat = 16
        let labelWidth = min(viewController.view.frame.width - 40, toastLabel.intrinsicContentSize.width + padding * 2)
        let labelHeight = toastLabel.intrinsicContentSize.height + padding
        toastLabel.frame = CGRect(
            x: (viewController.view.frame.width - labelWidth) / 2,
            y: viewController.view.frame.height - 120,
            width: labelWidth,
            height: labelHeight
        )
        
        viewController.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let padding: CGFloat = 16
        let labelWidth = min(view.frame.width - 40, toastLabel.intrinsicContentSize.width + padding * 2)
        let labelHeight = toastLabel.intrinsicContentSize.height + padding
        toastLabel.frame = CGRect(
            x: (view.frame.width - labelWidth) / 2,
            y: view.frame.height - 120,
            width: labelWidth,
            height: labelHeight
        )
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
                self.view.isUserInteractionEnabled = false
            }) { _ in
                toastLabel.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                completion?()
            }
        }
    }
    
    func showNoInternetAlert() {
          let alert = UIAlertController(
            title: StringConstants.AlertMessage.knoNetwork,
              message: StringConstants.AlertMessage.networkAvailablity,
              preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }

    func LoadingStart(msg : String) {
        ProgressDialog.show(in: self, message: msg)
    }
    
    func LoadingStop(){
        ProgressDialog.dismiss()
    }
    
    func popUp() {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func getTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)
            } else if let tab = base as? UITabBarController {
                return getTopViewController(base: tab.selectedViewController)
            } else if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            }
            return base
        }
    
    func handleTouchOutsideView(_ touches: Set<UITouch>, targetView: UIView, dismissAction: @escaping () -> Void) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if !targetView.frame.contains(location) {
                dismissAction()
            }
        }
    }
}

