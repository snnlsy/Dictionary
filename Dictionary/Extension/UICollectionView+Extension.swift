//
//  UICollectionView+Extension.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import UIKit

extension UICollectionView {
    
    func reloadDataAsync() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}
