//
//  UIViewController+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        String(String(describing: self).split(separator: "<").first!)
    }
    
    static func createWithNib(nibName: String? = nil) -> Self {
        func createWithNib<T: UIViewController>(nibName: String?) -> T {
            let nibName = nibName ?? T.identifier
            return T.init(nibName: nibName, bundle: Bundle(for: T.self))
        }
        
        return createWithNib(nibName: nibName)
    }
}

