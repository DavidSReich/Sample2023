//
//  GiphyModelTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class GiphyModelTests: XCTestCase {
    func testGiphyModel() {
        let jsonData = BaseTestUtilities.getGiphyModelData()

        let result: Result<GiphyModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let giphyModel):
            XCTAssertEqual(200, giphyModel.meta.status)
            XCTAssertEqual("OK", giphyModel.meta.msg)

            XCTAssertEqual(3, giphyModel.data.count)
            XCTAssertEqual("This is the title1", giphyModel.data[0].title)
            XCTAssertEqual("This is the title2", giphyModel.data[1].title)
            XCTAssertEqual("This is the title3", giphyModel.data[2].title)
        case .failure(let referenceError):
            XCTFail("Could not decode GiphyModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

    func testFishGiphyModel() {
        let jsonData = BaseTestUtilities.getFishGiphyModelData()

        let result: Result<GiphyModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let giphyModel):
            XCTAssertEqual(200, giphyModel.meta.status)
            XCTAssertEqual("OK", giphyModel.meta.msg)

            XCTAssertEqual(3, giphyModel.data.count)
            XCTAssertEqual("This is the title1", giphyModel.data[0].title)
            XCTAssertEqual("This is the title2", giphyModel.data[1].title)
            XCTAssertEqual("This is the title3", giphyModel.data[2].title)
        case .failure(let referenceError):
            XCTFail("Could not decode GiphyModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
