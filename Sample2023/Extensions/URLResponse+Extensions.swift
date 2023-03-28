//
//  URLResponse+Extensions.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Foundation

extension URLResponse {
    func validate(mimeType: String?) -> SampleError? {
        if let mimeType = mimeType,
           let mime = self.mimeType,
           mime != mimeType {
            print("Response type not \(mimeType): \(String(describing: mime))")
            return .wrongMimeType(targeMimeType: mimeType, receivedMimeType: self.mimeType ?? "missing type")
        }

        guard let httpUrlResponse = self as? HTTPURLResponse else {
            print("Response not HTTPURLResponse: \(self).")
            return .notHttpURLResponse
        }

        guard httpUrlResponse.statusCode == 200 else {
            print("Bad response statusCode = \(httpUrlResponse.statusCode)")
            return .responseNot200(responseCode: httpUrlResponse.statusCode)
        }

        return nil
    }
}
