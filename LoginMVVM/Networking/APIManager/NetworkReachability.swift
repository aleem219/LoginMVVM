//
//  NetworkReachbility.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
import Network
import SystemConfiguration

import Network

public class InternetConnectionManager {
    
    private init() { }
    
    private static let monitor = NWPathMonitor()
    private static let queue = DispatchQueue.global(qos: .background)
    private static var isConnected: Bool = false
    
    public static func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            if path.status == .satisfied {
                print("Internet is available.")
            } else {
                print("No internet connection.")
            }
        }
        
        // Set initial state immediately without waiting for handler
        isConnected = monitor.currentPath.status == .satisfied
    }
    
    public static func stopMonitoring() {
        monitor.cancel()
    }
    
    public static func isConnectedToNetwork() -> Bool {
        return isConnected
    }
}
