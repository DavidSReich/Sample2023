//
//  SampleError.swift
//  Sample2023
//
//  Created by David S Reich on 16/3/2023.
//

import Foundation

public enum SampleError: Error, Equatable {
    public static func == (lhs: SampleError, rhs: SampleError) -> Bool {
        lhs.errorName == rhs.errorName
    }

    // Session/network errors
    case dataTask(error: Error)
    case notConnected
    case noResponse
    case notHttpURLResponse
    case responseNot200(responseCode: Int)
    case apiNotHappy(message: String)
    case wrongMimeType(targeMimeType: String, receivedMimeType: String)
    case noData

    // "api", data and JSON errors
    case badURL
    indirect case noFetchJSON(sampleError: SampleError)   // recursive!!!
    case decodeJSON(reason: String)

    /*
     Most of these should be more user friendly and less technical.
     This is a job for the UX/CX people.
     */

    public var errorDescription: String? {
        switch self {
        case .dataTask(let error):
            return "Error getting data: \(error)"
        case .notConnected:
            return "Not connected to network.  Please try again later."
        case .noResponse:
            return "Query failed to return a response code"
        case .notHttpURLResponse:
            return "Query response was not a Http URL response"
        case .responseNot200(let responseCode):
            return "Query failed with response code: \(responseCode)"
        case .apiNotHappy(let message):
            return message
        case let .wrongMimeType(targeMimeType, receivedMimeType):
            return "Response was not \(targeMimeType).  Was: \(receivedMimeType)"
        case .noData:
            return "Query did not return any data"

        case .badURL:
            // this also isn't helpful to the user unless they were able to enter inappropriate characters
            return "Unable to construct a valid URL"
        case .noFetchJSON(let sampleError):
            if let errorDescription = sampleError.errorDescription {
                return "Couldn't fetch JSON: \(errorDescription)"
            } else {
                return "Couldn't fetch JSON"
            }
        case .decodeJSON(let reason):
            return "Couldn't decode JSON: \(reason)"
        }
    }

    public var errorName: String {
        switch self {
        case .dataTask:
            return "dataTask"
        case .notConnected:
            return "notConnected"
        case .noResponse:
            return "noResponse"
        case .notHttpURLResponse:
            return "notHttpURLResponse"
        case .responseNot200:
            return "responseNot200"
        case .apiNotHappy:
            return "apiNotHappy"
        case .wrongMimeType:
            return "wrongMimeType"
        case .noData:
            return "noData"
        case .badURL:
            return "badURL"
        case .noFetchJSON:
            return "noFetchJSON"
        case .decodeJSON:
            return "decodeJSON"
        }
    }
}
