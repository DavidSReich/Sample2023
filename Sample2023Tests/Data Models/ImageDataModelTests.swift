//
//  ImageDataModelTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class ImageDataModelTests: XCTestCase {
    func testImageDataModel() {
        let jsonData = BaseTestUtilities.getImageDataModelData()

        let result: Result<ImageDataModel, SampleError> = jsonData.decodeData()

        switch result {
        case .success(let imageDataModel):
            XCTAssertEqual("This is the title", imageDataModel.title)
            XCTAssertEqual(["abc", "efg", "hij"], imageDataModel.tags)

            XCTAssertEqual(BaseTestUtilities.largeHeight, imageDataModel.largeImageSize.height)
            XCTAssertEqual(BaseTestUtilities.largeWidth, imageDataModel.largeImageSize.width)
            XCTAssertEqual(BaseTestUtilities.largeImagePath, imageDataModel.largeImagePath)

            XCTAssertEqual(BaseTestUtilities.height, imageDataModel.imageSize.height)
            XCTAssertEqual(BaseTestUtilities.width, imageDataModel.imageSize.width)
            XCTAssertEqual(BaseTestUtilities.imagePath, imageDataModel.imagePath)
        case .failure(let referenceError):
            XCTFail("Could not decode ImageDataModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
