//
//  NetworkMonitor.swift
//  TripPD
//
//  Created by 김상규 on 10/3/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    var isConnected = false
    private var isMonitoring = false
    
    private init() { }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        monitor.start(queue: queue)
        
        checkConnect()
    }
    
    func checkConnect() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            if path.status == .satisfied {
                self.isConnected = true
            } else {
                self.isConnected = false
            }
        }
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        isMonitoring = false
        monitor.cancel()
    }
}

