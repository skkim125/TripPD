//
//  LocationManager.swift
//  TripPD
//
//  Created by 김상규 on 2/17/25.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .restricted, .denied:
            // 권한 거부 처리
            break
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
}

