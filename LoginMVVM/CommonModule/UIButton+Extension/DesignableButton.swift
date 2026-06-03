//
//  DesignableButton.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 03/06/26.
//

import Foundation
import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
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
    
    // MARK: - Background Colors (State)
    @IBInspectable var normalBackgroundColor: UIColor = .clear {
        didSet { updateStateColors() }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor = .clear {
        didSet { updateStateColors() }
    }
    
    @IBInspectable var disabledBackgroundColor: UIColor = .clear {
        didSet { updateStateColors() }
    }
    
    // MARK: - Title Colors (State)
    @IBInspectable var normalTitleColor: UIColor = .white {
        didSet { updateStateTitleColors() }
    }
    
    @IBInspectable var highlightedTitleColor: UIColor = .lightGray {
        didSet { updateStateTitleColors() }
    }
    
    @IBInspectable var disabledTitleColor: UIColor = .gray {
        didSet { updateStateTitleColors() }
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
    
    // MARK: - Icon
    @IBInspectable var leftIcon: UIImage? = nil {
        didSet { updateIcon() }
    }
    
    @IBInspectable var rightIcon: UIImage? = nil {
        didSet { updateIcon() }
    }
    
    @IBInspectable var iconPadding: CGFloat = 8 {
        didSet { updateIcon() }
    }
    
    @IBInspectable var iconTint: UIColor = .white {
        didSet { updateIcon() }
    }
    
    // MARK: - Gradient
    @IBInspectable var gradientStartColor: UIColor = .clear {
        didSet { updateGradient() }
    }
    
    @IBInspectable var gradientEndColor: UIColor = .clear {
        didSet { updateGradient() }
    }
    
    @IBInspectable var isHorizontalGradient: Bool = false {
        didSet { updateGradient() }
    }
    
    // MARK: - Private
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAll()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        gradientLayer?.cornerRadius = cornerRadius
    }
    
    private func setupAll() {
        updateLayer()
        updatePadding()
        updateStateColors()
        updateStateTitleColors()
        updateIcon()
        updateGradient()
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
        contentEdgeInsets = UIEdgeInsets(
            top: paddingTop,
            left: paddingLeft,
            bottom: paddingBottom,
            right: paddingRight
        )
    }
    
    // MARK: - Update State Colors
    private func updateStateColors() {
        setBackgroundColor(normalBackgroundColor, for: .normal)
        setBackgroundColor(highlightedBackgroundColor, for: .highlighted)
        setBackgroundColor(disabledBackgroundColor, for: .disabled)
    }
    
    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIColor.clear.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
    
    // MARK: - Update Title Colors
    private func updateStateTitleColors() {
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        setTitleColor(disabledTitleColor, for: .disabled)
    }
    
    // MARK: - Update Icon
    private func updateIcon() {
        if let left = leftIcon {
            setImage(left.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = iconTint
            semanticContentAttribute = .forceLeftToRight
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -iconPadding, bottom: 0, right: iconPadding)
        } else if let right = rightIcon {
            setImage(right.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = iconTint
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: iconPadding, bottom: 0, right: -iconPadding)
        }
    }
    
    // MARK: - Update Gradient
    private func updateGradient() {
        gradientLayer?.removeFromSuperlayer()
        guard gradientStartColor != .clear, gradientEndColor != .clear else { return }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.cornerRadius = cornerRadius
        gradient.startPoint = isHorizontalGradient ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        gradient.endPoint   = isHorizontalGradient ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}
