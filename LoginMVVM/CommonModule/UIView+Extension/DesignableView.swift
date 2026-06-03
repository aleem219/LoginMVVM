//
//  DesignableView.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 03/06/26.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
    
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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateLayer()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateLayer()
    }
    
    // MARK: - Update
    private func updateLayer() {
        // Corner
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners()
        
        // Border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        // Shadow
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = shadowOpacity == 0
    }
    
    private func maskedCorners() -> CACornerMask {
        // If none selected, apply all corners
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
}
