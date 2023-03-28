//
//  NetworkMonitor.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected = false

    // Prevents this to be created anywhere else.  Forces use of "shared"
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied

                // todo: testing needed to see if we should handle this
                if path.status == .requiresConnection {
                    print(">>> REQUIRES CONNECTION")
                }
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
