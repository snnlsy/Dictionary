//
//  SynonymTableViewCell.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 25.03.2023.
//

import UIKit

final class SynonymTableViewCell: UITableViewCell {

    @IBOutlet weak var synonymCollectionView: UICollectionView!
    var synonymList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        synonymCollectionView.delegate = self
        synonymCollectionView.dataSource = self
        
        let nib = UINib(nibName: K.Id.synonymCVCell, bundle: nil)
        synonymCollectionView.register(nib, forCellWithReuseIdentifier: K.Id.synonymCVCell)
    }
}


extension SynonymTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonymList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Id.synonymCVCell, for: indexPath) as! SynonymCollectionViewCell
        cell.synonymLabel.text = synonymList[indexPath.row]
        return cell
    }
}


extension SynonymTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = synonymList[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 16, height: 32)
    }
}
