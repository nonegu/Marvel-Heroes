//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

class HeroesTableViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var characters: [Character] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBarWithImage()
        configureSegmentedControl()
        configureCollectionView()
        
        MarvelAPI.getCharacters(limit: 30, offset: 0) { (result) in
            switch result {
            case .success(let chars):
                self.characters.append(contentsOf: chars)
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HeroCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(for: characters[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroDetail: HeroDetailViewController = HeroDetailViewController.createWithNib()
        present(heroDetail, animated: true, completion: nil)
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
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCellFromNib(HeroCell.self)
        collectionView.backgroundColor = .white
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 12, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
