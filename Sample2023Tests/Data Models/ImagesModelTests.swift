//
//  ImagesModelTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class ImagesModelTests: XCTestCase {
    func testImagesModel() {
        let jsonData = BaseTestUtilities.getImagesModelData()

        let result: Result<ImagesModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let imagesModel):
            XCTAssertEqual(BaseTestUtilities.largeHeightString, imagesModel.original.height)
            XCTAssertEqual(BaseTestUtilities.largeWidthString, imagesModel.original.width)
            XCTAssertEqual(BaseTestUtilities.largeImagePath, imagesModel.original.url)

            XCTAssertEqual(BaseTestUtilities.heightString, imagesModel.fixedWidth.height)
            XCTAssertEqual(BaseTestUtilities.widthString, imagesModel.fixedWidth.width)
            XCTAssertEqual(BaseTestUtilities.imagePath, imagesModel.fixedWidth.url)
        case .failure(let referenceError):
            XCTFail("Could not decode ImagesModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
