//
//  DetailTableViewCell.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 25.03.2023.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var definationLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none

        typeLabel.numberOfLines = 0
        
        definationLabel.numberOfLines = 0
        definationLabel.font = UIFont.systemFont(ofSize: 12.0)

        exampleLabel.numberOfLines = 0
        exampleLabel.isHidden = true
        exampleLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
}
