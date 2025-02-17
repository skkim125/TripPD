//
//  MapView.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var annotations: [CustomAnnotation]
    @Binding var showAlert: Bool
    @Binding var isSearched: Bool
    @Binding var isSelected: Bool
    
    @State private var selectedAnnotation: CustomAnnotation?
    var isSelectAnnotation: Bool = false
    var selectAction: ((PlaceInfo) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        context.coordinator.mapView = mapView
        context.coordinator.setupInitialCamera()
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        Task { @MainActor in
            if isSearched {
                context.coordinator.updateMapViewWhenSearch()
            }
        }
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView: MKMapView?
        var locationManager: CLLocationManager?
        
        init(parent: MapView) {
            self.parent = parent
            super.init()
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
}

extension MapView.Coordinator: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        Task { @MainActor in
            switch status {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                self.parent.showAlert = true
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, let mapView = mapView else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        Task { @MainActor in
            mapView.setRegion(region, animated: true)
            self.locationManager?.stopUpdatingLocation()
        }
    }
    
    func setupInitialCamera() {
        guard let mapView = mapView else { return }
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.51786, longitude: 126.88643)
        let mapCamera = MKMapCamera(lookingAtCenter: defaultCoordinate, fromDistance: 3000, pitch: 10, heading: 0)
        mapView.camera = mapCamera
    }
    
    func updateMapViewWhenSearch() {
        guard let mapView = mapView else { return }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(parent.annotations)
        
        guard !parent.annotations.isEmpty else { return }
        
        if parent.isSelected {
            if let selectedAnnotation = parent.selectedAnnotation {
                withAnimation {
                    mapView.camera.centerCoordinate = selectedAnnotation.coordinate
                }
                parent.isSelected = false
            }
        } else {
            var zoomRect = MKMapRect.null
            for annotation in parent.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(pointRect)
            }
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    let coordinate: CLLocationCoordinate2D
    let placeInfo: PlaceInfo
    
    init(placeInfo: PlaceInfo) {
        self.title = placeInfo.placeName
        let lat = Double(placeInfo.lat) ?? 0.0
        let lon = Double(placeInfo.lon) ?? 0.0
        print(lat, lon)
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.placeInfo = placeInfo
    }
}
