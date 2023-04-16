//
//  SynonymCollectionViewCell.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import UIKit

final class SynonymCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var synonymLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.cornerRadius = 15
        layer.borderColor = UIColor(hexString: "#E0E0E0").cgColor
    }
}
