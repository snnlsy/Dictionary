//
//  Constant.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 25.03.2023.
//

import UIKit

struct K {
    
    struct Id {
        static let storyBoard = "Main"
        static let detailVC = "DetailViewController"
        static let recentSeachTVCell = "RecentSeachTableViewCell"
        static let synonymCVCell = "SynonymCollectionViewCell"
        static let detailTVCell = "DetailTableViewCell"
        static let synonymTVCell = "SynonymTableViewCell"
    }
    
    struct Api {
        static let dictUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/"
        static let synonymUrl = "https://api.datamuse.com/words?rel_syn="
    }
    
    struct RecentSearch {
        static let headerLabel = "Recent Search"
    }
    
    struct Color {
        static let blurBorder = UIColor(hexString: "#3F5CFF")
    }
}
