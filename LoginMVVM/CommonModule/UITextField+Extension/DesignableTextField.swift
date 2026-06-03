//
//  DesignableTextField.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 03/06/26.
//

import Foundation
import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    // MARK: - Corner
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { updateLayer() }
    }
    
    @IBInspectable var topLeftCorner: Bool = false {
        didSet { updateLayer() }
    }
    
    @IBInspectable var topRightCorner: Bool = false {
        didSet { updateLayer() }
    }
    
    @IBInspectable var bottomLeftCorner: Bool = false {
        didSet { updateLayer() }
    }
    
    @IBInspectable var bottomRightCorner: Bool = false {
        didSet { updateLayer() }
    }
    
    // MARK: - Border
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { updateLayer() }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { updateLayer() }
    }
    
    // MARK: - Shadow
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet { updateLayer() }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { updateLayer() }
    }
    
    @IBInspectable var shadowOffsetX: CGFloat = 0 {
        didSet { updateLayer() }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 0 {
        didSet { updateLayer() }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { updateLayer() }
    }
    
    // MARK: - Padding
    @IBInspectable var paddingLeft: CGFloat = 0 {
        didSet { updatePadding() }
    }
    
    @IBInspectable var paddingRight: CGFloat = 0 {
        didSet { updatePadding() }
    }
    
    @IBInspectable var paddingTop: CGFloat = 0 {
        didSet { updatePadding() }
    }
    
    @IBInspectable var paddingBottom: CGFloat = 0 {
        didSet { updatePadding() }
    }
    
    // MARK: - Placeholder
    @IBInspectable var placeholderColor: UIColor = .lightGray {
        didSet { updatePlaceholder() }
    }
    
    @IBInspectable var placeholderFontSize: CGFloat = 14 {
        didSet { updatePlaceholder() }
    }
    
    /// 0 = Regular, 1 = Medium, 2 = Semibold, 3 = Bold
    @IBInspectable var placeholderFontWeight: Int = 0 {
        didSet { updatePlaceholder() }
    }
    
    // MARK: - Left Icon
    @IBInspectable var leftIcon: UIImage? = nil {
        didSet { updateLeftIcon() }
    }
    
    @IBInspectable var leftIconPadding: CGFloat = 8 {
        didSet { updateLeftIcon() }
    }
    
    @IBInspectable var leftIconTint: UIColor = .gray {
        didSet { updateLeftIcon() }
    }
    
    // MARK: - Right Icon
    @IBInspectable var rightIcon: UIImage? = nil {
        didSet { updateRightIcon() }
    }
    
    @IBInspectable var rightIconPadding: CGFloat = 8 {
        didSet { updateRightIcon() }
    }
    
    @IBInspectable var rightIconTint: UIColor = .gray {
        didSet { updateRightIcon() }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAll()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAll()
    }
    
    private func setupAll() {
        updateLayer()
        updatePadding()
        updatePlaceholder()
        updateLeftIcon()
        updateRightIcon()
    }
    
    // MARK: - Update Layer
    private func updateLayer() {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners()
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = shadowOpacity == 0
    }
    
    private func maskedCorners() -> CACornerMask {
        let noneSelected = !topLeftCorner && !topRightCorner && !bottomLeftCorner && !bottomRightCorner
        if noneSelected { return [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                   .layerMinXMaxYCorner, .layerMaxXMaxYCorner] }
        var corners: CACornerMask = []
        if topLeftCorner     { corners.insert(.layerMinXMinYCorner) }
        if topRightCorner    { corners.insert(.layerMaxXMinYCorner) }
        if bottomLeftCorner  { corners.insert(.layerMinXMaxYCorner) }
        if bottomRightCorner { corners.insert(.layerMaxXMaxYCorner) }
        return corners
    }
    
    // MARK: - Update Padding
    private func updatePadding() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: frame.height))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: frame.height))
        rightViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft,
                                             bottom: paddingBottom, right: paddingRight))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft,
                                             bottom: paddingBottom, right: paddingRight))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft,
                                             bottom: paddingBottom, right: paddingRight))
    }
    
    // MARK: - Update Placeholder
    private var resolvedFontWeight: UIFont.Weight {
        switch placeholderFontWeight {
        case 1:  return .medium
        case 2:  return .semibold
        case 3:  return .bold
        default: return .regular
        }
    }
    
    private func updatePlaceholder() {
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: UIFont.systemFont(ofSize: placeholderFontSize, weight: resolvedFontWeight)
            ]
        )
    }
    
    // MARK: - Update Left Icon
    private func updateLeftIcon() {
        guard let icon = leftIcon else {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: paddingLeft, height: frame.height))
            leftViewMode = .always
            return
        }
        let containerSize = frame.height > 0 ? frame.height : 44
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerSize + leftIconPadding, height: containerSize))
        let imageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = leftIconTint
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: leftIconPadding, y: (containerSize - 20) / 2, width: 20, height: 20)
        container.addSubview(imageView)
        leftView = container
        leftViewMode = .always
    }
    
    // MARK: - Update Right Icon
    private func updateRightIcon() {
        guard let icon = rightIcon else {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: paddingRight, height: frame.height))
            rightViewMode = .always
            return
        }
        let containerSize = frame.height > 0 ? frame.height : 44
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerSize + rightIconPadding, height: containerSize))
        let imageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = rightIconTint
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: rightIconPadding, y: (containerSize - 20) / 2, width: 20, height: 20)
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
    }
}
