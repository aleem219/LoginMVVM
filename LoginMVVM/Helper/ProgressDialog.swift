//
//  ProgressDialog.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 21/05/26.
//

import UIKit
import Foundation

class ProgressDialog {
    
    static private var overlayView: UIView?
    
    static func show(in viewController: UIViewController, message: String = "Signing in…") {
        guard overlayView == nil else { return }
        
        let overlay = UIView(frame: viewController.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.alpha = 0
        
        // Card
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.18
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
        card.layer.shadowRadius = 18
        card.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(card)
        
        // Spinner — custom green ring
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor(red: 0.16, green: 0.43, blue: 0.16, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        card.addSubview(spinner)
        
        // Label
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(white: 0.18, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(label)
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),

            spinner.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            spinner.centerXAnchor.constraint(equalTo: card.centerXAnchor),

            label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 7),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            label.centerXAnchor.constraint(equalTo: card.centerXAnchor),
        ])
        
        viewController.view.addSubview(overlay)
        overlayView = overlay
        
        // Animate in — scale + fade
        card.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
        UIView.animate(withDuration: 0.28, delay: 0,
                       usingSpringWithDamping: 0.72,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            overlay.alpha = 1
            card.transform = .identity
        }
    }
    
    static func dismiss() {
        guard let overlay = overlayView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            overlay.alpha = 0
            overlay.subviews.first?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            overlay.removeFromSuperview()
            overlayView = nil
        }
    }
}
