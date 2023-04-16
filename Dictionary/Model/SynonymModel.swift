//
//  SynonymModel.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

struct SynonymResultModel: Decodable {
    let result: [SynonymModel]
}

struct SynonymModel: Decodable {
    var word: String?
    var score: Int?
}
