//
//  LaunchScreenView.swift
//  Sample2023
//
//  Created by David S Reich on 21/3/2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("Giphy_Logo")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.9)
                .padding()

            HStack {
                Spacer()
                Text("Tags")
                    .font(.largeTitle)
                    .bold()
                    .scaleEffect(2.0)
                    .padding(.bottom)
                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                Text("Copyright © 2020, 2023 Stellar Software Pty Ltd. All rights reserved.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Spacer()
            }

            HStack {
                Image("PoweredBy_200px-White_HorizLogo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            }
        }
        .onAppear(perform: goAway)
    }

    private func goAway() {
        Task {
            try await Task.sleep(for: .seconds(3))
            isPresented = false
        }
    }
}

#Preview("LaunchScreenView SE") {
    @State var showLaunch = true

    return LaunchScreenView(isPresented: $showLaunch)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
}

#Preview("LaunchScreenView 11 Pro Max") {
    @State var showLaunch = true

    return LaunchScreenView(isPresented: $showLaunch)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
        .previewDisplayName("iPhone 11 Pro Max (13.4)")
}

#Preview("LaunchScreenView SE fixed layout") {
    @State var showLaunch = true

    return LaunchScreenView(isPresented: $showLaunch)
        .previewLayout(.fixed(width: 1136, height: 640))
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
}

#Preview("LaunchScreenView 11 Pro Max fixed layout") {
    @State var showLaunch = true

    return LaunchScreenView(isPresented: $showLaunch)
        .previewLayout(.fixed(width: 2688, height: 1242))
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
        .previewDisplayName("iPhone 11 Pro Max (13.4)")
}
