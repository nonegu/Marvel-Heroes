//
//  UIView+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

extension UIView {
    /// Default identifier to reuse in tableview, collectionview, map annotation etc.
    /// Returns the name of the file specified view.
    static var defaultReuseIdentifier: String {
        guard let substring: Substring = String(describing: self).split(separator: "<").first else {
            return String(describing: self)
        }
        return String(substring)
    }
    
    /// Configures `view.layer` shadow properties
    /// - Parameters:
    ///   - shadowColor: Color of shadow. Default is `.lightGray`
    ///   - shadowOpacity: Opacity of shadow. Default is `0.5`
    ///   - shadowOffset: Offset of shadow. Default is `.zero`
    ///   - shadowRadius: Radius of shadow. Default is `5`
    func configureShadow(
        shadowColor: CGColor = UIColor.lightGray.cgColor,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 5
    ) {
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    /// Sets layer mask to given corners rounded path
    /// - Parameters:
    ///   - radius: Radius value. Default is `20`
    ///   - corners: Corners to be rounded. Default is all
    func configureCorner(
        _ radius: CGFloat = 20,
        corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    ) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
}
