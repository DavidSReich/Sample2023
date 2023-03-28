//
//  BasicImageModelTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class BasicImageModelTests: XCTestCase {
    func testBasicModel() {
        let jsonData = BaseTestUtilities.getBasicImageData()

        let result: Result<BasicImageModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let basicImageModel):
            XCTAssertEqual(BaseTestUtilities.largeHeightString, basicImageModel.height)
            XCTAssertEqual(BaseTestUtilities.largeWidthString, basicImageModel.width)
            XCTAssertEqual(BaseTestUtilities.largeImagePath, basicImageModel.url)
        case .failure(let referenceError):
            XCTFail("Could not decode BasicImageModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
