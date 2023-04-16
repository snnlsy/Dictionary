//
//  SearchViewModel.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    func reloadData()
}

final class SearchViewModel {
    
    weak var delegate: SearchViewModelProtocol?
    private var recentSearchList = DataContainer<String>()
    
    func config() {
        recentSearchList.limit = 5
    }
    
    var recentSearchListCount: Int {
        get {
            recentSearchList.count
        }
    }
    
    func appendNewSearch(_ word: String) {
        recentSearchList.push(word)
        delegate?.reloadData()
    }
    
    func getRecentSearchList() -> [String] {
        return recentSearchList.getArray()
    }
}
