//
//  Data+Extensions.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Foundation

extension Data {
    func decodeData<T: Decodable>() -> Result<T, SampleError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(T.self, from: self)
            return .success(result)
        } catch {
            print("decode error: \(error)")
            return .failure(.decodeJSON(reason: "\(error)"))
        }
    }

    // handy for debugging
    func prettyPrintData() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                if let detailString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("json:\n\(detailString)")
                }
            }
        }
    }
}
