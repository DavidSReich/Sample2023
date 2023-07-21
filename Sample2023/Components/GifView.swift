//
//  GifView.swift
//  Sample2023
//
//  Created by David S Reich on 18/3/2023.
//

import SwiftUI
import SwiftyGif

struct GifView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(gifURL: url)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.setGifFromURL(url)
    }
}

#Preview("GifView") {
    VStack {
        GifView(url: Bundle.main.url(forResource: "fish", withExtension: "gif")!)
            .layoutPriority(-1)
        GifView(url: Bundle.main.url(forResource: "fish", withExtension: "gif")!)
            .layoutPriority(-1)
    }
    .frame(width: 200, height: 300)
}
