//
//  MapView.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var annotations: [MKPointAnnotation]
    @Binding var showAlert: Bool
    @Binding var isSelected: Bool
    
    var type: MapType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        context.coordinator.mapView = mapView
        switch type {
        case .myAround:
            break
        case .addPlace:
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tapLocation(_:)))
            mapView.addGestureRecognizer(tapGesture)
            context.coordinator.isSelectedAction()
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        
        context.coordinator.updateAnnotations(annotations)
        
        if isSelected {
            print("\(self.annotations)")
            context.coordinator.isSelectedAction()
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        var mapView: MKMapView?
        var locationManager: CLLocationManager?
        var localAnnotations: [MKPointAnnotation] = []
        
        init(parent: MapView) {
            self.parent = parent
            super.init()
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            let region = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            mapView.setRegion(region, animated: true)
        }
        
        func updateAnnotations(_ annotations: [MKPointAnnotation]) {
            self.localAnnotations = annotations
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
        }
    }
}

extension MapView.Coordinator: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // 권한 요청
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.parent.showAlert = true // 권한이 거부된 경우 알림 표시
            }
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation() // 위치 업데이트 시작
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        mapView?.setRegion(region, animated: true)
        
        DispatchQueue.main.async {
            self.locationManager?.stopUpdatingLocation()
        }
    }
}

extension MapView.Coordinator {
    @objc func tapLocation(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        let coordinate = (gesture.view as! MKMapView).convert(location, toCoordinateFrom: gesture.view)
        
        convertGeocoder(coordinate) { value in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = value
            
            self.parent.annotations.removeAll()
            self.parent.annotations.append(annotation)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                if let map = self.mapView {
                    withAnimation {
                        self.mapView(map, didSelect: map.view(for: annotation) ?? MKAnnotationView())
                    }
                }
            }
        }
    }
    
    func isSelectedAction() {
        guard let annotation = localAnnotations.first else { return }
        
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let map = self.mapView {
                withAnimation {
                    map.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func convertGeocoder(_ location: CLLocationCoordinate2D, _ handler: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        var address = ""
        
        geocoder.reverseGeocodeLocation(CLLocation(
            latitude: location.latitude,
            longitude: location.longitude),
                                        preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
                
                address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
                handler(address)
            }
        }
    }
}

enum MapType {
    case myAround
    case addPlace
}
