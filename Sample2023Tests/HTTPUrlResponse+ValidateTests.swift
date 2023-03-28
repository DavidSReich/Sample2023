//
//  HTTPUrlResponse+ValidateTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class HTTPUrlResponse_ValidateTests: XCTestCase {
    private var goodHttpUrlResponse = HTTPURLResponse()
    private var bad401HttpUrlResponse = HTTPURLResponse()
    private var bad403HttpUrlResponse = HTTPURLResponse()
    private var badHttpUrlResponse = HTTPURLResponse()
    private var goodUrlResponse = URLResponse()
    private var error: SampleError?
    private var dummyURL = URL(string: "https://a.b.com")
    private var dummyMimeType = "dummyMimeType"

    override func setUp() {
        if let goodHttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 200, httpVersion: nil, headerFields: nil) {
            self.goodHttpUrlResponse = goodHttpUrlResponse
        } else {
            XCTFail("Couldn't create goodHTTPUrlResponse!!")
        }

        if let badHttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 500, httpVersion: nil, headerFields: nil) {
            self.badHttpUrlResponse = badHttpUrlResponse
        } else {
            XCTFail("Couldn't create badHTTPUrlResponse!!")
        }

        if let bad401HttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 401, httpVersion: nil, headerFields: nil) {
            self.bad401HttpUrlResponse = bad401HttpUrlResponse
        } else {
            XCTFail("Couldn't create bad401HttpUrlResponse!!")
        }

        if let bad403HttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 403, httpVersion: nil, headerFields: nil) {
            self.bad403HttpUrlResponse = bad403HttpUrlResponse
        } else {
            XCTFail("Couldn't create bad403HttpUrlResponse!!")
        }

        self.goodUrlResponse = URLResponse(url: dummyURL!, mimeType: dummyMimeType, expectedContentLength: 1000, textEncodingName: nil)
    }

    func testUrlResponse() {
        XCTAssertEqual(SampleError.notHttpURLResponse, goodUrlResponse.validate(mimeType: nil))
    }

    func testWrongMime() {
        guard let error = goodUrlResponse.validate(mimeType: "wrongMime") else {
            XCTFail("urlResponse should fail with wrongMimeType.  But it didn't fail.")
            return
        }

        if case SampleError.wrongMimeType(targeMimeType: let targetMimeType,
                                          receivedMimeType: let receivedMimeType) = error {
            XCTAssertEqual("wrongMime", targetMimeType)
            XCTAssertEqual("dummyMimeType", receivedMimeType)
            // supposed to fail like this because we set "wrongMime" here
        } else {
            XCTFail("urlResponse should fail with wrongMimeType.  Instead failed with \(error).")
        }
    }

    func test401HttpUrlResponseCode() {
        guard let error = bad401HttpUrlResponse.validate(mimeType: nil) else {
            XCTFail("urlResponse should fail with apiNotHappy.  But it didn't fail.")
            return
        }

        if case .responseNot200(let responseCode, _) = error {
            if responseCode == 401 {
                let result: Result<MessageModel, SampleError> = BaseTestUtilities.getMessageModelData().decodeData()

                if case .success(let messageModel) = result {
                    let message = messageModel.message
                    let error = SampleError.apiNotHappy(message: message)
                    if case SampleError.apiNotHappy(message: let message) = error {
                        XCTAssertEqual("Invalid authentication credentials", message)
                    } else {
                        XCTFail("urlResponse should fail with apiNotHappy.  Instead failed with \(error).")
                    }

                    return
                }
            }
        }

        XCTFail("urlResponse should fail with apiNotHappy.  Instead failed with \(error).")
    }

    func test403HttpUrlResponseCode() {
        guard let error = bad403HttpUrlResponse.validate(mimeType: nil) else {
            XCTFail("urlResponse should fail with apiNotHappy.  But it didn't fail.")
            return
        }

        if case .responseNot200(let responseCode, _) = error {
            if responseCode == 403 {
                let result: Result<MessageModel, SampleError> = BaseTestUtilities.getMessageModelData().decodeData()

                if case .success(_) = result {
                    let message = "API Key might be incorrect.  Go to Settings to check it."
                    let error = SampleError.apiNotHappy(message: message)
                    if case SampleError.apiNotHappy(message: let message) = error {
                        XCTAssertEqual("API Key might be incorrect.  Go to Settings to check it.", message)
                    } else {
                        XCTFail("urlResponse should fail with apiNotHappy.  Instead failed with \(error).")
                    }

                    return
                }
            }
        }

        XCTFail("urlResponse should fail with apiNotHappy.  Instead failed with \(error).")
    }

    func testBadResponseCode() {
        guard let error = badHttpUrlResponse.validate(mimeType: nil) else {
            XCTFail("urlResponse should fail with responseNot200.  But it didn't fail.")
            return
        }

        if case SampleError.responseNot200(responseCode: let responseCode, data: _) = error {
            XCTAssertEqual(responseCode, 500)
            // supposed to fail at this point because a we set a responseCode == 500 here.
        } else {
            XCTFail("urlResponse should fail with responseNot200.500 error.  Instead failed with \(error).")
        }
    }
}
