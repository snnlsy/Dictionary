//
//  DetailViewModel.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

protocol DetailViewModelProtocol: AnyObject {
    func reloadData()
    func setPhoneticLabel(_ text: String)
}

enum WordType: String {
    case noun
    case verb
    case adjective
}

final class DetailViewModel {
    
    weak var delegate: DetailViewModelProtocol?
    
    private let word: String
    var wordDetailList: [String: [Detail]] = [
        WordType.noun.rawValue: [],
        WordType.verb.rawValue: [],
        WordType.adjective.rawValue: []
    ]
    
    var wordDetailListCount: Int {
        get {
            (wordDetailList[WordType.noun.rawValue]?.count ?? 0) +
            (wordDetailList[WordType.verb.rawValue]?.count ?? 0) +
            (wordDetailList[WordType.adjective.rawValue]?.count ?? 0)
        }
    }
    
    var wordDetailFlatList: [Detail] {
        get {
            (wordDetailList[WordType.noun.rawValue] ?? []) +
            (wordDetailList[WordType.verb.rawValue] ?? []) +
            (wordDetailList[WordType.adjective.rawValue] ?? [])
        }
    }
    
    var synonymList: [String] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    init(_ word: String) {
        self.word = word
        getSynonymData()
        getDetailData()
    }
    
    private func getDetailData() {
        let urlStr = K.Api.dictUrl + self.word
        guard let url = URL(string: urlStr) else { return }
        
        NetworkService.shared.fetchData(url: url) { [weak self] dataResponse in
            guard let self = self else { return }
            switch dataResponse {
            case .success(let data):
                guard let prefix = "{\"result\":".data(using: .utf8),
                      let suffix = "}".data(using: .utf8) else { return }
                let modifiedData = prefix + data + suffix
                do {
                    let decodedData = try JSONDecoder().decode(DetailResultModel.self, from: modifiedData)
                    let meanings = decodedData.result.first?.meanings ?? []
                    let phonetic = decodedData.result.first?.phonetic ?? ""
                    if decodedData.result.count > 0 {
                        for detailModel in meanings {
                            var indexCount = 0
                            for detail in detailModel.definitions ?? [] {
                                let wordDetail = Detail()
                                let type = detailModel.partOfSpeech ?? ""
                                wordDetail.index = indexCount
                                wordDetail.type = type
                                wordDetail.defination = detail.definition ?? ""
                                wordDetail.example = detail.example
                                indexCount += 1
                                self.wordDetailList[type]?.append(wordDetail)
                            }
                        }
                    }
                    self.delegate?.setPhoneticLabel(phonetic)
                    self.delegate?.reloadData()
                } catch {
                    return
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func getSynonymData() {
        let urlStr = K.Api.synonymUrl + self.word
        guard let url = URL(string: urlStr) else { return }

        NetworkService.shared.fetchData(url: url) { [weak self] dataResponse in
            switch dataResponse {
            case .success(let data):
                guard let prefix = "{\"result\":".data(using: .utf8),
                      let suffix = "}".data(using: .utf8) else { return }
                let modifiedData = prefix + data + suffix
                do {
                    let decodedData = try JSONDecoder().decode(SynonymResultModel.self, from: modifiedData)
                    let sortedData = decodedData.result.sorted(by: {
                        $0.score ?? 0 > $1.score ?? 0
                    })
                    var synonymList: [String] = []
                    for data in sortedData {
                        synonymList.append(data.word ?? "")
                    }
                    let first5 = synonymList.enumerated().compactMap {
                        $0.offset < 5 ? $0.element : nil
                    }
                    self?.synonymList = first5
                } catch {
                    return
                }
            case .failure(_):
                return
            }
        }
    }
}
