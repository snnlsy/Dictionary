//
//  RecentSearchTableViewCell.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import UIKit

final class RecentSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var recentSearchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
