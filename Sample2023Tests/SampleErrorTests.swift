//
//  SampleErrorTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class SampleErrorTests: XCTestCase {
    func testErrors() {
        XCTAssertEqual(SampleError.apiNotHappy(message: "Bad API call").errorDescription,
                       "Bad API call")
        XCTAssertEqual(SampleError.badURL.errorDescription,
                       "Unable to construct a valid URL")
        XCTAssertEqual(SampleError.dataTask(error: SampleError.badURL).errorDescription,
                       "Error getting data: badURL")
        XCTAssertEqual(SampleError.decodeJSON(reason: "Bad JSON, bad JSON").errorDescription,
                       "Couldn't decode JSON: Bad JSON, bad JSON")
        XCTAssertEqual(SampleError.noData.errorDescription,
                       "Query did not return any data")
        XCTAssertEqual(SampleError.noFetchJSON(sampleError: SampleError.badURL).errorDescription,
                       "Couldn't fetch JSON: Unable to construct a valid URL")
        XCTAssertEqual(SampleError.noResponse.errorDescription,
                       "Query failed to return a response code")
        XCTAssertEqual(SampleError.notHttpURLResponse.errorDescription,
                       "Query response was not a Http URL response")
        XCTAssertEqual(SampleError.responseNot200(responseCode: 500).errorDescription,
                       "Query failed with response code: 500")
        XCTAssertEqual(SampleError.wrongMimeType(targeMimeType: "Good Mime", receivedMimeType: "Bad Mime").errorDescription,
                       "Response was not Good Mime.  Was: Bad Mime")
    }
}
