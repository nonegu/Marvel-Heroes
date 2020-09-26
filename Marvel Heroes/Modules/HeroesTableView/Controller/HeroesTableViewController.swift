//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

private enum ViewState: Int {
    case all
    case favorites
}

class HeroesTableViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var characters: [Character] = []
    private var isLoading = false
    private var loadingView: LoadingReusableView?
    private var paginationControlData = PaginationControlData(pageSize: 30)
    private var viewState: ViewState = .all
    
    private var favoriteCharacters: [Character] {
        let objects = RealmService.getObjects(ofType: RealmCharacter.self)
        return objects.map { Character(realmCharacter: $0) }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBarWithImage()
        configureSegmentedControl()
        configureNoDataLabel()
        configureCollectionView()
        
        getCharacters(page: paginationControlData.currentPage)
    }
    
    // MARK: - IBActions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        viewState = ViewState.init(rawValue: segmentedControl.selectedSegmentIndex) ?? .all
        collectionView.reloadData()
        
        noDataLabel.isHidden = !(viewState == .favorites && favoriteCharacters.isEmpty)
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewState {
        case .all:
            return characters.count
        case .favorites:
            return favoriteCharacters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HeroCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.heroImageView.image = nil
        switch viewState {
        case .all:
            cell.configure(for: characters[indexPath.row])
        case .favorites:
            cell.configure(for: favoriteCharacters[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character: Character
        switch viewState {
        case .all:
            character = characters[indexPath.row]
        case .favorites:
            character = favoriteCharacters[indexPath.row]
        }
        
        let heroDetail = HeroDetailViewController.create(character: character, delegate: self)
        present(heroDetail, animated: true, completion: nil)
    }
}

// MARK: - HeroDetailViewControllerDelegate
extension HeroesTableViewController: HeroDetailViewControllerDelegate {
    func heroDetail(_ vc: HeroDetailViewController, didRemoveFavorite char: Character) {
        switch viewState {
        case .favorites:
            collectionView.reloadData()
            noDataLabel.isHidden = !(viewState == .favorites && favoriteCharacters.isEmpty)
        case .all:
            break
        }
    }
}

// MARK: - API Calls
extension HeroesTableViewController {
    private func getCharacters(page: Int) {
        isLoading = true
        
        let offset = page * paginationControlData.pageSize
        let limit = paginationControlData.pageSize
        MarvelAPI.getCharacters(limit: limit, offset: offset) { (result) in
            switch result {
            case .success(let chars):
                self.isLoading = false
                
                let indexPaths = self.createNewIndexPathsFor(chars: chars)
                
                DispatchQueue.main.async {
                    switch self.viewState {
                    case .all:
                        self.collectionView.performBatchUpdates({
                            self.characters.append(contentsOf: chars)
                            self.collectionView.insertItems(at: indexPaths)
                        }, completion: nil)
                    case .favorites:
                        self.characters.append(contentsOf: chars)
                    }
                }
                
                self.paginationControlData.currentPage += 1
                
                if chars.count < self.paginationControlData.pageSize {
                    self.paginationControlData.isLastPage = true
                }
            case .failure(let error):
                self.isLoading = false
                print(error)
            }
        }
    }
}

// MARK: - UICollectionView FooterView & Infinite Scroll
extension HeroesTableViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.defaultReuseIdentifier, for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if viewState != .favorites {
                self.loadingView?.activityIndicator.startAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == characters.count - 5 && !self.isLoading {
            getCharacters(page: paginationControlData.currentPage + 1)
        }
    }
}

// MARK: - UI Manipulations
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
    
    private func configureNoDataLabel() {
        noDataLabel.font = .helveticaNeueBoldWith(size: 20)
        noDataLabel.textAlignment = .center
        noDataLabel.text = "No Hero Found"
        noDataLabel.isHidden = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCellFromNib(HeroCell.self)
        collectionView.registerSupplementaryView(LoadingReusableView.self, viewKind: UICollectionView.elementKindSectionFooter)
        collectionView.backgroundColor = .white
    }
}

// MARK: - Helpers
extension HeroesTableViewController {
    private func createNewIndexPathsFor(chars: [Character]) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        var lastItem = self.characters.isEmpty ? 0 : (self.characters.count)
        
        chars.forEach { _ in
            let indexPath = IndexPath(item: lastItem, section: 0)
            indexPaths.append(indexPath)
            lastItem += 1
        }
        
        return indexPaths
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 12, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 0)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(55.0))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
