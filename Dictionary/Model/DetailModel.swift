//
//  DetailModel.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

struct DetailResultModel: Decodable {
    let result: [DetailModel]
}

struct DetailModel: Decodable {
    let word, phonetic: String?
    let meanings: [Meaning]?
    let sourceUrls: [String]?
}

struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms, antonyms: [String]?
}

struct Definition: Decodable {
    let definition: String?
    let example: String?
}

class Detail {
    var index: Int = 0
    var type: String = ""
    var defination: String = ""
    var example: String? = nil
}
