//
//  ImageView.swift
//  Sample2023
//
//  Created by David S Reich on 22/3/2023.
//

import SwiftUI

struct ImageView: View {
    var imageDataModel: ImageDataModel

    @State private var fullScaleAmount = 1.0
    @State private var shrinkScaleAmount = 1.0
    @State private var shrinkImage = false
    @State private var scaleTimer: Timer?
    @State private var rotationAmount = 360.0

    private enum ChangeMode {
        case shrinking
        case expanding
        case spinning

        var nextMode: ChangeMode {
            switch self {
            case .shrinking:
                    .spinning
            case .expanding:
                    .shrinking
            case .spinning:
                    .expanding
            }
        }
    }

    @State private var changeMode = ChangeMode.shrinking

    private let shrinkFactor = 0.25
    private let spinTime = 3.0
    private let defaultTime = 0.35

    private var displayScaleAmount: Double {
        shrinkImage ? shrinkScaleAmount : fullScaleAmount
    }

    private var animateTime: Double {
        changeMode == .spinning ? spinTime : defaultTime
    }

    var body: some View {
        ZStack {
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))

            GifView(url: URL(string: imageDataModel.largeImagePath)!)
                .frame(width: imageDataModel.largeImageSize.width, height: imageDataModel.largeImageSize.height)
                .border(Color.orange, width: 5)
                .shadow(color: .orange, radius: 15)
                .scaleEffect(displayScaleAmount)
                .rotationEffect(.degrees(rotationAmount))
        }
        .onAppear {
            // So far this is handling device rotation correctly
            // further testing would be nice to make sure this doesn't need to be more dynamic to handle device rotation???
            fullScaleAmount = fitImageInScreen()
            shrinkScaleAmount = fullScaleAmount * shrinkFactor

            setUpAnimation()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(imageDataModel.title ?? "No Image?")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fitImageInScreen() -> CGFloat {
        let size = UIScreen.main.bounds.size

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

    private func setUpAnimation() {
        withAnimation(.easeIn(duration: animateTime)) {
            if changeMode == .spinning {
                rotationAmount *= -1
            } else {
                shrinkImage.toggle()
            }
        } completion: {
            changeMode = changeMode.nextMode
            if changeMode == .shrinking {
                Task {
                    try await Task.sleep(for: .seconds(1))
                    setUpAnimation()
                }
            } else {
                setUpAnimation()
            }
        }
    }
}

#Preview("ImageView") {
    NavigationStack {
        ImageView(imageDataModel: BaseTestUtilities.getFishImageModel()!)
    }
}
