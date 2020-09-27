//
//  UIViewController+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

typealias alertHandler = ((UIAlertAction) -> Void)

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
    
    /// Creates and populates an alertView.
    /// - Parameters:
    ///   - vc: The  view controller, on which alertView will be presented.
    ///   - title: Title of the alertView.
    ///   - message: Body of the alertView.
    ///   - buttonTitles: Defines titles of the requested buttons.
    ///   - buttonActions: Action handler of the buttons.
    /// - Note:
    ///    This method will create the alertView with the specified handlers. If no handlers specified, it will create the action with the handler equals to nil.
    ///    If the size of the `buttonActions` array smaller than the `buttonTitles`, it will only create handlers for the buttons from left the right.
    func showAlertWithAction(vc: UIViewController, title: String, message: String, buttonTitles: [String], buttonActions: [alertHandler?]) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for buttonNumber in 0..<buttonTitles.count {
            if buttonNumber < buttonActions.count {
                let action = UIAlertAction(title: buttonTitles[buttonNumber], style: .default, handler: buttonActions[buttonNumber])
                controller.addAction(action)
            } else {
                let action = UIAlertAction(title: buttonTitles[buttonNumber], style: .default, handler: nil)
                controller.addAction(action)
            }
        }
        
        DispatchQueue.main.async {
            vc.present(controller, animated: true)
        }
    }
}
