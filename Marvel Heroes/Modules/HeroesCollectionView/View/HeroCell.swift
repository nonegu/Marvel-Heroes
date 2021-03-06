//
//  CollectionViewCell.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit
import Kingfisher

class HeroCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    @IBOutlet weak var heroAliasLabel: UILabel!
    @IBOutlet weak var moreInfoStackView: UIStackView!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(heroAliasLabel, fontSize: 16, isBold: true)
        heroAliasLabel.numberOfLines = 0
        
        configure(moreInfoLabel, text: "More info", isBold: true)
        
        containerView.configureCorner(10)
        containerView.configureShadow()
        
        configureHeroImageView()
    }
}

extension HeroCell {
    private func configureHeroImageView() {
        self.heroImageView.contentMode = .scaleAspectFit
        self.heroImageView.configureCorner(10, corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
    
    func configure(for character: Character) {
        self.heroAliasLabel.text = character.name
        
        self.heroImageView.kf.indicatorType = .activity
        
        guard let imageExtension = character.thumbnail?.imageExtension else { return }
        
        let thumbnailImageURL = character.thumbnail?.imageURL?.thumbnailImageURL(.standardLarge, fileExtension: imageExtension)
        self.heroImageView.kf.setImage(with: thumbnailImageURL)
    }
}
