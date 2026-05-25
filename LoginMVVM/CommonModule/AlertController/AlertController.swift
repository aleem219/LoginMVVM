//
//  AlertController.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 21/05/26.
//
import UIKit
import Foundation


class AlertController {
    static func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIViewController.getTopViewController()?.present(alert, animated: true)
    }
}
