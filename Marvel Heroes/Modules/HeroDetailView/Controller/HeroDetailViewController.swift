//
//  HeroesDetailViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import UIKit

protocol HeroDetailViewControllerDelegate: class {
    func heroDetail(_ vc: HeroDetailViewController, didRemoveFavorite char: Character)
}

class HeroDetailViewController: UIViewController {
    
    // MARK: - Initialization
    static func create(
        character: Character,
        delegate: HeroDetailViewControllerDelegate? = nil
    ) -> HeroDetailViewController {
        let vc: HeroDetailViewController = HeroDetailViewController.createWithNib()
        vc.character = character
        vc.delegate = delegate
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
    private var favoriteButton = UIButton(type: .custom)
    private var minHeaderImageHeight: CGFloat = 60
    private var character: Character!
    private var comics: [Comic] = []
    private var isLoading = false
    
    private weak var delegate: HeroDetailViewControllerDelegate?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeaderImageView()
        configureScrollView()
        configureCollectionView()
        configureLabels()
        configureFavoriteButton()
        
        getComics(dateSince: createSince2005Date())
    }
}

// MARK: - UIScrollViewDelegate
extension HeroDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        
        let y = headerImageView.frame.height - (scrollView.contentOffset.y + headerImageView.frame.height)
        let height = min(max(y, minHeaderImageHeight), 400)
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension HeroDetailViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource
extension HeroDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ComicCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(for: comics[indexPath.row])
        return cell
    }
}

// MARK: - API Calls
extension HeroDetailViewController {
    private func getComics(dateSince: Date) {
        guard let id = character.id else { return }
        isLoading = true
        
        MarvelAPI.getComics(
            for: id,
            dateSince: dateSince,
            orderBy: .onsaleDateDesc,
            limit: 10
        ) { (result) in
            switch result {
            case .success(let comics):
                self.isLoading = false
                self.comics = comics
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                self.isLoading = false
                
                let errorMessage: String
                switch error {
                case let .errorOccured(message):
                    errorMessage = message
                default:
                    errorMessage = error.localizedDescription
                }
                
                self.showAlertWithAction(
                    vc: self, title: "Sorry!",
                    message: errorMessage,
                    buttonTitles: ["OK"],
                    buttonActions: [nil]
                )
            }
        }
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
    
    private func configureFavoriteButton() {
        favoriteButton.tintColor = .systemPink
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        
        if let _ = RealmService.getObjects(ofType: RealmCharacter.self).filter("id == \(character.id ?? 0)").first {
            favoriteButton.isSelected = true
        }
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
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.registerCellFromNib(ComicCell.self)
        collectionView.registerSupplementaryView(LoadingReusableView.self, viewKind: UICollectionView.elementKindSectionFooter)
    }
    
    private func configureLabels() {
        aliasLabel.font = .helveticaNeueBoldWith(size: 16)
        aliasLabel.text = character.name
        
        nameLabel.text = String(character.id ?? 0)
        nameLabel.font = .helveticaNeueMediumWith(size: 14)
        
        descriptionLabel.text = character.description
        descriptionLabel.font = .helveticaNeueRegularWith(size: 14)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 12, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(collectionView.frame.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createSince2005Date() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2005
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let userCalendar = Calendar.current
        return userCalendar.date(from: dateComponents) ?? Date()
    }
    
    @objc private func favoriteButtonTapped() {
        if !favoriteButton.isSelected {
            addHeroToFavorites()
        } else {
            removeHeroFromFavorites()
        }
    }
    
    private func removeHeroFromFavorites() {
        guard let object = RealmService.getObjects(ofType: RealmCharacter.self).filter("id == \(character.id ?? 0)").first else { return }
        RealmService.delete(object: object) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(_):
                self.favoriteButton.isSelected.toggle()
                self.delegate?.heroDetail(self, didRemoveFavorite: self.character)
            case .failure(let error):
                self.showAlertWithAction(
                    vc: self, title: "Sorry!",
                    message: error.localizedDescription,
                    buttonTitles: ["OK"],
                    buttonActions: [nil]
                )
            }
        }
    }
    
    private func addHeroToFavorites() {
        let hero = RealmCharacter(from: character)
        RealmService.save(objects: hero) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(_):
                self.favoriteButton.isSelected.toggle()
            case .failure(let error):
                self.showAlertWithAction(
                    vc: self, title: "Sorry!",
                    message: error.localizedDescription,
                    buttonTitles: ["OK"],
                    buttonActions: [nil]
                )
            }
        }
    }
}
