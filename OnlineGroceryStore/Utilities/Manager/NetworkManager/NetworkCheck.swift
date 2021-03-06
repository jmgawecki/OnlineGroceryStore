//
//  InternetCheck.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 06/03/2021.
//

import Network

enum IsNetworkOn {
    case connection
    case noConnection
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func internetCheck() -> NWPath.Status? {
        let monitor = NWPathMonitor()
        var connectionStatus: NWPath.Status?
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied { connectionStatus = .satisfied }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        return connectionStatus
    }
    
    
}
