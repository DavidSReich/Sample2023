//
//  NetworkMonitor.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Network
import Observation

@Observable class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected = false

    // "private" prevents this from being created anywhere else.  Forces use of "shared"
    private init() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                print(">>>> isConnected: \(self.isConnected)")
            }

            // todo: testing needed to see if we should handle this
            if path.status == .requiresConnection {
                print(">>> REQUIRES CONNECTION")
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
