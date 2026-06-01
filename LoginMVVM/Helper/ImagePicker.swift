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
import MobileCoreServices
import UniformTypeIdentifiers

// MARK: - Media Result

public enum MediaResult {
    case image(UIImage)
    case videoURL(URL)
    case documentURL(URL)
}

// MARK: - Delegate

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    
    func didSelect(media: MediaResult?)
}


public extension ImagePickerDelegate {
    func didSelect(image: UIImage?) {}
    func didSelect(media: MediaResult?) {}
}

// MARK: - ImagePicker

open class ImagePicker: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Private types
    
    private enum PickerMode {
        case imageOnly
        case videoOnly
        case imageAndVideo
        case document
    }
    
    // MARK: - Properties
    
    private let pickerController: UIImagePickerController
    private lazy var documentPickerController: UIDocumentPickerViewController = makeDocumentPicker()
    
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    // MARK: - Init
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
    }
    
    // MARK: - Public entry points
    
    public func present(from sourceView: UIView) {
        requestPhotoAuthorization { [weak self] granted in
            guard let self else { return }
            if granted {
                self.showFullActionSheet(sourceView: sourceView)
            } else {
                self.showPermissionDeniedAlert()
            }
        }
    }
    
    public func presentImagePicker(from sourceView: UIView) {
        requestPhotoAuthorization { [weak self] granted in
            guard let self else { return }
            if granted {
                self.showActionSheet(for: .imageOnly, sourceView: sourceView)
            } else {
                self.showPermissionDeniedAlert()
            }
        }
    }
    
    public func presentVideoPicker(from sourceView: UIView) {
        requestPhotoAuthorization { [weak self] granted in
            guard let self else { return }
            if granted {
                self.showActionSheet(for: .videoOnly, sourceView: sourceView)
            } else {
                self.showPermissionDeniedAlert()
            }
        }
    }
    
    public func presentDocumentPicker() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.presentationController?.present(self.documentPickerController, animated: true)
        }
    }
    
    // MARK: - Action sheet builders
    
    private func showFullActionSheet(sourceView: UIView) {
        let alert = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
        
        // --- Image ---
        let imageSheet = UIAlertAction(title: "📷  Photo", style: .default) { [weak self] _ in
            self?.showActionSheet(for: .imageOnly, sourceView: sourceView)
        }
        alert.addAction(imageSheet)
        
        // --- Video ---
        let videoSheet = UIAlertAction(title: "🎥  Video", style: .default) { [weak self] _ in
            self?.showActionSheet(for: .videoOnly, sourceView: sourceView)
        }
        alert.addAction(videoSheet)
        
        // --- Document ---
        let docAction = UIAlertAction(title: "📄  Document", style: .default) { [weak self] _ in
            self?.presentDocumentPicker()
        }
        alert.addAction(docAction)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        configurePopover(alert, sourceView: sourceView)
        presentationController?.present(alert, animated: true)
    }
    
    private func showActionSheet(for mode: PickerMode, sourceView: UIView) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        switch mode {
        case .imageOnly:
            pickerController.mediaTypes = ["public.image"]
            pickerController.allowsEditing = true
            pickerController.videoQuality = .typeHigh
            
        case .videoOnly:
            pickerController.mediaTypes = ["public.movie"]
            pickerController.allowsEditing = true
            pickerController.videoQuality = .typeHigh
            pickerController.videoMaximumDuration = 300 // 5 minutes
            
        case .imageAndVideo:
            pickerController.mediaTypes = ["public.image", "public.movie"]
            pickerController.allowsEditing = false
            
        case .document:
            presentDocumentPicker()
            return
        }
        
        if let cameraAction = makePickerAction(for: .camera, title: "Take \(mode == .videoOnly ? "Video" : "Photo")") {
            alert.addAction(cameraAction)
        }
        if let libraryAction = makePickerAction(for: .photoLibrary, title: mode == .videoOnly ? "Video Library" : "Photo Library") {
            alert.addAction(libraryAction)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        configurePopover(alert, sourceView: sourceView)
        presentationController?.present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    private func makePickerAction(for sourceType: UIImagePickerController.SourceType,
                                  title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return nil }
        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.pickerController.sourceType = sourceType
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    private func makeDocumentPicker() -> UIDocumentPickerViewController {
        let types: [UTType]
        if #available(iOS 14.0, *) {
            types = [.pdf, .plainText, .rtf, .spreadsheet, .presentation,
                     .image, .movie, .audio, .data, .item]
        } else {
            types = [UTType.item]
        }
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false
        return controller
    }
    
    private func configurePopover(_ alert: UIAlertController, sourceView: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
    }
    
    // MARK: - Authorization
    
    private func requestPhotoAuthorization(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            DispatchQueue.main.async { completion(true) }
        case .restricted, .denied:
            DispatchQueue.main.async { completion(false) }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            DispatchQueue.main.async { completion(false) }
        }
    }
    
    // MARK: - Permission denied
    
    private func showPermissionDeniedAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(
                title: "Permission Denied",
                message: "Please allow photo/video access in Settings to continue.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            self.presentationController?.present(alert, animated: true)
        }
    }
    
    // MARK: - Internal dispatch
    
    private func finish(with media: MediaResult?) {
        delegate?.didSelect(media: media)
        if case .image(let img) = media {
            delegate?.didSelect(image: img)
        } else if media == nil {
            delegate?.didSelect(image: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        finish(with: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        let mediaType = info[.mediaType] as? String
        
        if mediaType == "public.image" {
            let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
            finish(with: image.map { .image($0) })
            
        } else if mediaType == "public.movie" {
            if let videoURL = info[.mediaURL] as? URL {
                finish(with: .videoURL(videoURL))
            } else {
                finish(with: nil)
            }
            
        } else {
            finish(with: nil)
        }
    }
}

// MARK: - UIDocumentPickerDelegate

extension ImagePicker: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            finish(with: nil)
            return
        }
        
        let fileName = url.lastPathComponent
        let fileExtension = url.pathExtension.uppercased()
        print("Selected pdf file: \(fileName)")
        
        let accessed = url.startAccessingSecurityScopedResource()
        finish(with: .documentURL(url))
        if accessed { url.stopAccessingSecurityScopedResource() }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        finish(with: nil)
    }
}
