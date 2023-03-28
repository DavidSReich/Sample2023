//
//  ImageDataModel.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import UIKit

struct ImageDataModel: Decodable, Hashable {
    static func == (lhs: ImageDataModel, rhs: ImageDataModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var title: String?
    private var slug: String
    private var images: ImagesModel

    var id: UUID {
        UUID()
    }

    var tags: [String] {
        var tags = slug.components(separatedBy: "-")
        tags.removeLast()   // remove the id
        return tags
    }

    var imagePath: String {
        images.fixedWidth.url
    }

    var imageSize: CGSize {
        CGSize(width: Int(images.fixedWidth.width) ?? 0, height: Int(images.fixedWidth.height) ?? 0)
    }

    var largeImagePath: String {
        images.original.url
    }

    var largeImageSize: CGSize {
        CGSize(width: Int(images.original.width) ?? 0, height: Int(images.original.height) ?? 0)
    }

    func scaledSize(width: CGFloat) -> CGSize {
        let scaleRatio = width / (imageSize.width != 0 ? imageSize.width : 1)
        return CGSize(width: imageSize.width * scaleRatio, height: imageSize.height * scaleRatio)
    }
}
