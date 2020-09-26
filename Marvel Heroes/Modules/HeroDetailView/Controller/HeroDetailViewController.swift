//
//  HeroesDetailViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
    var indexPath: IndexPath?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentInset = UIEdgeInsets(top: headerImageView.frame.height, left: 0, bottom: scrollView.contentInset.bottom, right: 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: headerImageView.frame.height, left: 0, bottom: scrollView.contentInset.bottom, right: 0)
        scrollView.delegate = self
        headerImageView.image = UIImage.init(named: "marvelNavBarIcon")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        view.addSubview(headerImageView)
        
        aliasLabel.text = "Wolverine"
        nameLabel.text = "James Hawwlet"
        descriptionLabel.text = "Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel, Is a fictional Character appering in American comic books published by Marvel"
    }
}

extension HeroDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = headerImageView.frame.height - (scrollView.contentOffset.y + headerImageView.frame.height)
        let height = min(max(y, 60), 400)
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}
