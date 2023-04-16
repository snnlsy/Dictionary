//
//  URL+Extension.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

extension URL {

    typealias JsonResult<T> = (Result<T, APIError>) -> Void
    
    func fetchJsonData<T: Decodable>(completion: @escaping JsonResult<T>) {
        NetworkService.shared.fetchData(url: self) { dataResponse in
            switch dataResponse {
            case .success(let data):
                do {
                    let res = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(res))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
