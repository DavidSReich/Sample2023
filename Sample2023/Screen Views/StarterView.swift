//
//  StarterView.swift
//  Sample2023
//
//  Created by David S Reich on 21/3/2023.
//

import SwiftUI

struct StarterView: View {
    private var dataSource: DataSource
    @State private var showLaunchScreen = true
    private var mainViewModel: MainViewModel

    init(dataSource: DataSource) {
        self.dataSource = dataSource
        _ = NetworkMonitor.shared.isConnected   // do this once to prime it?
        mainViewModel = MainViewModel(dataSource: self.dataSource, userSettings: UserDefaultsManager.userSettings)
    }

    var body: some View {
        Group {
            if showLaunchScreen {
                LaunchScreenView(isPresented: $showLaunchScreen)
            } else {
                MainView(mainViewModel: mainViewModel)
            }
        }
    }
}

#Preview("StartView") {
    StarterView(dataSource: MockDataSource())
}
