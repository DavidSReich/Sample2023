//
//  Sample2023App.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import SwiftUI

@main
struct Sample2023App: App {
    var dataSource = DataSource()

    var body: some Scene {
        WindowGroup {
            StarterView(dataSource: dataSource)
        }
    }
}
