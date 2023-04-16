//
//  Data+Extension.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

extension Data {
    
    func decodeData<T: Decodable>() -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: self)
            return decodedData
        } catch {
            return nil
        }
    }
}
