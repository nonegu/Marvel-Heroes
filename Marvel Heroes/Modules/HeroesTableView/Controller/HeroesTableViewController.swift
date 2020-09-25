//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

class HeroesTableViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBarWithImage()
        configureSegmentedControl()
    }
}

// MARK: - Helpers
extension HeroesTableViewController {
    private func configureNavBarWithImage() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let marvelImage = UIImage(named: "marvelNavBarIcon") ?? UIImage()
        let marvelImageView = UIImageView(image: marvelImage)
        marvelImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = marvelImageView
    }
    
    private func configureSegmentedControl() {
        segmentedControl.selectedSegmentTintColor = .systemRed
        segmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        segmentedControl.tintColor = .white
    }
}
