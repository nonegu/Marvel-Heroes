//
//  UICollectionView+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 25.09.2020.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<Cell: UICollectionViewCell>(
        identifier: String = Cell.defaultReuseIdentifier,
        indexPath: IndexPath
    ) -> Cell {
        self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
    }
    
    func registerCell<Cell: UICollectionViewCell>(
        _ cellClass: Cell.Type,
        identifier: String = Cell.defaultReuseIdentifier
    ) {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    func registerCellFromNib<Cell: UICollectionViewCell>(
        _ cellClass: Cell.Type,
        nibName: String = Cell.defaultReuseIdentifier,
        identifier: String = Cell.defaultReuseIdentifier
    ) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerSupplementaryView<View: UIView>(
        _ viewClass: View.Type,
        viewKind: String = UICollectionView.elementKindSectionHeader,
        nibName: String = View.defaultReuseIdentifier,
        identifier: String = View.defaultReuseIdentifier
    ) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: viewKind, withReuseIdentifier: identifier)
    }
}
