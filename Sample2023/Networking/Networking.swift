//
//  Networking.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Foundation

class Networking {
    static func loadData<T: Decodable>(urlString: String, mimeType: String? = nil) async throws -> Result<T, SampleError> {
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            print("urlString: \(urlString)")
            print("Cannot make URL")
            return .failure(.badURL)
        }

        guard NetworkMonitor.shared.isConnected else {
            return .failure(SampleError.notConnected)
        }

        print(">>>>> url: \(url)")
        let (data, response) = try await URLSession.shared.data(from: url)

        if let networkingError = response.validate(mimeType: mimeType) {
            data.prettyPrintData()

            return .failure(networkingError)
        }

        guard !data.isEmpty else {
            print("No data.")
            return .failure(.noData)
        }

        return data.decodeData()
    }
}
