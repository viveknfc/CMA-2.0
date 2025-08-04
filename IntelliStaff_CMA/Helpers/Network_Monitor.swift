//
//  Network_Monitor.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 18/07/25.
//

import Network

enum NetworkMonitor {
    static let shared = NWPathMonitor()
    private static let queue = DispatchQueue(label: "NetworkMonitor")

    static var isConnected: Bool {
        let status = shared.currentPath.status
        return status == .satisfied
    }

    static func start() {
        shared.start(queue: queue)
    }

    static func stop() {
        shared.cancel()
    }
}

