//
//  ImagePicker.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 21/05/26.
//
//
import Foundation
import UIKit
import Photos

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject, UINavigationControllerDelegate {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showActionSheet(sourceView: sourceView)
            }
        case .restricted, .denied:
            showPermissionDeniedAlert()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.showActionSheet(sourceView: sourceView)
                    }
                case .restricted, .denied:
                    DispatchQueue.main.async {
                        self.showPermissionDeniedAlert()
                    }
                default:
                    break
                }
            }
        default:
            break
        }
    }

    private func showActionSheet(sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take Photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Permission Denied",
            message: "Please allow photo access in Settings to upload an image.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        self.presentationController?.present(alert, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
