//
//  StarterView.swift
//  Sample2023
//
//  Created by David S Reich on 21/3/2023.
//

import SwiftUI

struct StarterView: View {
    var dataSource: DataSource
    @State private var showLaunchScreen = true
    @ObservedObject var mainViewModel: MainViewModel

    init(dataSource: DataSource) {
        self.dataSource = dataSource
        _ = NetworkMonitor.shared.isConnected   // do this once to prime it?
        mainViewModel = MainViewModel(dataSource: self.dataSource, userSettings: UserDefaultsManager.getUserSettings())
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

struct StarterView_Previews: PreviewProvider {
    static var dataSource = MockDataSource()

    static var previews: some View {
        StarterView(dataSource: dataSource)
    }
}
