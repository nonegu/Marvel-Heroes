//
//  CollectionViewCell.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    @IBOutlet weak var heroAliasLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var moreInfoStackView: UIStackView!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        heroImageView.image = UIImage(named: "marvelNavBarIcon")
        configure(heroAliasLabel, text: "Wolverine", fontSize: 16, isBold: true)
        configure(heroNameLabel, text: "James Hawwlet")
        configure(shortDescriptionLabel, text: "Is a fictional Character appering in American comic books published by Marvel", fontSize: 12)
        configure(moreInfoLabel, text: "More info", isBold: true)
        
        containerView.configureCorner(10)
        containerView.configureShadow()
    }
}

extension HeroCell {
    private func configure(
        _ label: UILabel,
        text: String? = nil,
        fontSize: CGFloat = 14,
        isBold: Bool = false
    ) {
        if isBold {
            label.font = .helveticaNeueBoldWith(size: fontSize)
        } else {
            label.font = .helveticaNeueRegularWith(size: fontSize)
        }
        
        label.text = text
        label.numberOfLines = 0
    }
}
