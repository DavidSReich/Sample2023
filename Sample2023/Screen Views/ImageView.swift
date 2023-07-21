//
//  ImageView.swift
//  Sample2023
//
//  Created by David S Reich on 22/3/2023.
//

import SwiftUI

struct ImageView: View {
    var imageDataModel: ImageDataModel

    var body: some View {
        ZStack {
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))

            GifView(url: URL(string: imageDataModel.largeImagePath)!)
                .frame(width: imageDataModel.largeImageSize.width, height: imageDataModel.largeImageSize.height)
                .border(Color.orange, width: 5)
                .shadow(color: .orange, radius: 15)
                .scaleEffect(fitImageInScreen(size: UIScreen.main.bounds.size))
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(imageDataModel.title ?? "No Image?")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fitImageInScreen(size: CGSize) -> CGFloat {
        guard size.height > 44,
              size.width != 0 else {
            return 1
        }

        let screenHeight = size.height - 44
        let screenWidth = size.width

        let imageHeight = imageDataModel.largeImageSize.height
        let imageWidth = imageDataModel.largeImageSize.width

        let image2ScreenHeightRatio = imageHeight / screenHeight
        let image2ScreenWidthRatio = imageWidth / screenWidth
        let maxImage2ScreenRatio = max(image2ScreenWidthRatio, image2ScreenHeightRatio)

        let scaleAmount = 0.9 / maxImage2ScreenRatio

        return scaleAmount
    }
}

#Preview("ImageView") {
    NavigationStack {
        ImageView(imageDataModel: BaseTestUtilities.getFishImageModel()!)
    }
}
