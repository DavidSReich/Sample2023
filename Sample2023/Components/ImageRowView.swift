//
//  ImageRowView.swift
//  Sample2023
//
//  Created by David S Reich on 17/3/2023.
//

import SwiftUI

struct ImageRowView: View {
    var imageDataModel: ImageDataModel
    @State var showOnLeft: Bool

    private var imageSize: CGSize {
        let minDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return imageDataModel.scaledSize(width: minDimension * 0.5)
    }

    @State private var toggleTimer: Timer?

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
        .onAppear {
            repeatToggle()
        }
        .onDisappear {
            clearTimer()
        }
        .animation(.interpolatingSpring(stiffness: 20, damping: 1), value: showOnLeft)
    }

    private func clearTimer() {
        if let timer = toggleTimer {
            timer.invalidate()
            toggleTimer = nil
        }
    }

    private func repeatToggle() {
        clearTimer()

        toggleTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 3.5 ..< 4.5),
                                           repeats: true) {_ in
            showOnLeft.toggle()
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
