//
//  MetaModelTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class MetaModelTests: XCTestCase {
    func testMetaModel() {
        let jsonData = BaseTestUtilities.getMetaModelData()

        let result: Result<MetaModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let metaModel):
            XCTAssertEqual(200, metaModel.status)
            XCTAssertEqual("OK", metaModel.msg)
        case .failure(let referenceError):
            XCTFail("Could not decode MetaModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }}
