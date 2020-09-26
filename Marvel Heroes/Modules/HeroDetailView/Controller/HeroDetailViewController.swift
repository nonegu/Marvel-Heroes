//
//  HeroesDetailViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    // MARK: - Initialization
    static func create(character: Character) -> HeroDetailViewController {
        let vc: HeroDetailViewController = HeroDetailViewController.createWithNib()
        vc.character = character
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
    private var minHeaderImageHeight: CGFloat = 60
    private var character: Character!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeaderImageView()
        configureScrollView()
        configureLabels()
    }
}

// MARK: - UIScrollViewDelegate
extension HeroDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = headerImageView.frame.height - (scrollView.contentOffset.y + headerImageView.frame.height)
        let height = min(max(y, minHeaderImageHeight), 400)
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}

// MARK: - Helpers
extension HeroDetailViewController {
    private func configureHeaderImageView() {
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.kf.indicatorType = .activity
        view.addSubview(headerImageView)
        
        guard let imageExtension = character.thumbnail?.imageExtension else { return }
        
        let thumbnailImageURL = character.thumbnail?.imageURL?.thumbnailImageURL(.standardXLarge, fileExtension: imageExtension)
        headerImageView.kf.setImage(with: thumbnailImageURL)
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(
            top: headerImageView.frame.height,
            left: 0,
            bottom: -minHeaderImageHeight,
            right: 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(
            top: headerImageView.frame.height,
            left: 0,
            bottom: -minHeaderImageHeight,
            right: 0)
    }
    
    private func configureLabels() {
        aliasLabel.font = .helveticaNeueBoldWith(size: 16)
        aliasLabel.text = character.name
        
        nameLabel.text = String(character.id ?? 0)
        nameLabel.font = .helveticaNeueMediumWith(size: 14)
        
        descriptionLabel.text = character.description
        descriptionLabel.font = .helveticaNeueRegularWith(size: 14)
    }
}
