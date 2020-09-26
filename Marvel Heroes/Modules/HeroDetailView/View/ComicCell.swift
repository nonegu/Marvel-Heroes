//
//  ComicCell.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

class ComicCell: UICollectionViewCell {
    
    // MARK: -IBOutlets
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure(titleLabel, fontSize: 12, isBold: true)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        configure(detailLabel, fontSize: 12)
        detailLabel.textAlignment = .center
        
        configureComicImageView()
    }
}

extension ComicCell {
    private func configureComicImageView() {
        self.comicImageView.contentMode = .scaleAspectFit
    }
    
    func configure(for comic: Comic) {
        self.titleLabel.text = comic.title
        
        if let comicPages = comic.pageCount {
            self.detailLabel.text = comicPages > 1 ? "\(comicPages) pages" : "\(comicPages) page"
        } else {
            self.detailLabel.text = nil
        }
        
        self.comicImageView.kf.indicatorType = .activity
        
        guard let imageExtension = comic.thumbnail?.imageExtension else { return }
        
        let thumbnailImageURL = comic.thumbnail?.imageURL?.thumbnailImageURL(.standardMedium, fileExtension: imageExtension)
        self.comicImageView.kf.setImage(with: thumbnailImageURL)
    }
}
