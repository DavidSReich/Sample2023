//
//  ImageRowView.swift
//  Sample2023
//
//  Created by David S Reich on 17/3/2023.
//

import SwiftUI

struct ImageRowView: View {
    var imageDataModel: ImageDataModel
    var showOnLeft: Bool

    private var imageSize: CGSize {
        let minDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return imageDataModel.scaledSize(width: minDimension * 0.5)
    }

    var body: some View {
        HStack {
            if !showOnLeft {
                Spacer()
            }

            GifView(url: URL(string: imageDataModel.imagePath)!)
                .frame(width: imageSize.width, height: imageSize.height)
                .fixedSize()
                .border(Color.blue, width: 5)
                .shadow(color: .blue, radius: 10)
                .padding()
                .accessibility(label: Text(imageDataModel.title ?? ""))
                .accessibility(hint: Text("Shows large image."))

            if showOnLeft {
                Spacer()
            }
        }
    }
}

#Preview("ImageRowView") {
    VStack(spacing: 0) {
        ImageRowView(imageDataModel: BaseTestUtilities.getFishImageModel()!, showOnLeft: true)
            .background(.green)
        ImageRowView(imageDataModel: BaseTestUtilities.getFishImageModel()!, showOnLeft: false)
            .background(.red)
    }
    .padding(.horizontal, 16)
}
