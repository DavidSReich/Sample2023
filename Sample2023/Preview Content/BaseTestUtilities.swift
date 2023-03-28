//
//  BaseTestUtilities.swift
//  Sample2023
//
//  Created by David S Reich on 17/3/2023.
//

import UIKit

class BaseTestUtilities {
    static let numberOfImagesInGiphyModel = 3
    static let tagsString = "abc-efg-hij"
    static let imagePath = "https://media1.giphy.com/media/YnH5fDZPcNJfi/200w.gif"
    static let largeImagePath = "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.gif"
    static let width = CGFloat(282)
    static let height = CGFloat(402)
    static let widthString = "282"
    static let heightString = "402"
    static let largeWidth = CGFloat(280)
    static let largeHeight = CGFloat(400)
    static let largeWidthString = "280"
    static let largeHeightString = "400"

    private static let basicImageJSONString =
    #"""
        {
            "frames": "60",
            "hash": "627ff8a082be87d1e8ce2a9f7a0ffbdb",
            "height": "400",
            "mp4": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.mp4",
            "mp4_size": "226554",
            "size": "88540",
            "url": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.gif",
            "webp": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.webp",
            "webp_size": "92686",
            "width": "280"
        }
    """#

    private static let basicImageJSONString2 =
    #"""
        {
            "frames": "60",
            "hash": "627ff8a082be87d1e8ce2a9f7a0ffbdb",
            "height": "402",
            "mp4": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.mp4",
            "mp4_size": "226554",
            "size": "88540",
            "url": "https://media1.giphy.com/media/YnH5fDZPcNJfi/200w.gif",
            "webp": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.webp",
            "webp_size": "92686",
            "width": "282"
        }
    """#

    private static let metaModelString =
    """
        {
            "status": 200,
            "msg": "OK"
        }
    """

    private static let messageModelString =
    """
        {
            "message": "Invalid authentication credentials"
        }
    """

    private static func imagesModelString() -> String {
        return """
            {
                "original": \(basicImageJSONString),
                "fixed_width": \(basicImageJSONString2)
            }
        """
    }

    private static func imageDataModelString() -> String {
        return """
            {
                "title": "This is the title",
                "slug": "abc-efg-hij-klm",
                "images": \(imagesModelString())
            }
        """
    }

    private static func giphyModelString() -> String {
        return """
            {
                "meta" : {
                  "status" : 200,
                  "msg" : "OK"
                },
                "data":
                    [{
                        "title": "This is the title1",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    },
                    {
                        "title": "This is the title2",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    },
                    {
                        "title": "This is the title3",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    }]
            }
        """
    }

    private static let basicFishImageJSONString =
    #"""
        {
            "height": "240",
            "url": "{FISH_URL}",
            "width": "550"
        }
    """#

    private static func fishImageJSONString() -> String {
        if let url = Bundle.main.url(forResource: "fish", withExtension: "gif") {
            return basicFishImageJSONString.replacingOccurrences(of: "{FISH_URL}", with: url.absoluteString)
        }

        return ""
    }

    private static func fishImagesModelString() -> String {
        return """
            {
                "original": \(fishImageJSONString()),
                "fixed_width": \(fishImageJSONString())
            }
        """
    }

    private static func fishImageDataModelString() -> String {
        return """
            {
                "title": "This is the title",
                "slug": "abc-efg-hij-klm",
                "images": \(fishImagesModelString())
            }
        """
    }

    private static func fishGiphyModelString() -> String {
        return """
            {
                "meta" : {
                  "status" : 200,
                  "msg" : "OK"
                },
                "data":
                    [{
                        "title": "This is the title1",
                        "slug": "abc-efg-hij-klm",
                        "images": \(fishImagesModelString())
                    },
                    {
                        "title": "This is the title2",
                        "slug": "abc-efg-hij-klm",
                        "images": \(fishImagesModelString())
                    },
                    {
                        "title": "This is the title3",
                        "slug": "abc-efg-hij-klm",
                        "images": \(fishImagesModelString())
                    }]
            }
        """
    }

    class func getBasicImageData() -> Data {
        return Data(basicImageJSONString.utf8)
    }

    class func getMetaModelData() -> Data {
        return Data(metaModelString.utf8)
    }

    class func getMessageModelData() -> Data {
        return Data(messageModelString.utf8)
    }

    class func getImagesModelData() -> Data {
        return Data(imagesModelString().utf8)
    }

    class func getImageDataModelData() -> Data {
        return Data(imageDataModelString().utf8)
    }

    class func getFishImageDataModelData() -> Data {
        return Data(fishImageDataModelString().utf8)
    }

    class func getGiphyModelData() -> Data {
        return Data(giphyModelString().utf8)
    }

    class func getFishGiphyModelData() -> Data {
        return Data(fishGiphyModelString().utf8)
    }

    class func getFishImageModel() -> ImageDataModel? {
        let jsonData = Self.getFishImageDataModelData()
        let result: Result<ImageDataModel, SampleError> = jsonData.decodeData()
        // if decode fails it will be caught in another test.

        if case .success(let imageDataModel) = result {
            return imageDataModel
        }

        return nil
    }
}
