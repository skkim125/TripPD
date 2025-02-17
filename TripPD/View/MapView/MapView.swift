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
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        Task { @MainActor in
            if isSearched {
                updateMapViewWhenSearch(mapView)
            } else {
                updateMapViewWhenInit(mapView, locationManager: context.coordinator.locationManager)
            }
        }
    }
        
    private func updateMapViewWhenSearch(_ mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        guard !annotations.isEmpty else { return }
        
        if isSelected {
            if let selectedAnnotation = selectedAnnotation {
                withAnimation {
                    mapView.camera.centerCoordinate = selectedAnnotation.coordinate
                }
                isSelected = false
            }
        } else {
            var zoomRect = MKMapRect.null
            for annotation in annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(pointRect)
            }
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
    
    private func updateMapViewWhenInit(_ mapView: MKMapView, locationManager: CLLocationManager?) {
        if let locationManager = locationManager,
           locationManager.authorizationStatus == .denied {
            self.showAlert = true
            let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.51786, longitude: 126.88643)
            let mapCamera = MKMapCamera(lookingAtCenter: defaultCoordinate, fromDistance: 3000, pitch: 10, heading: 0)
            mapView.camera = mapCamera
        } else {
            let mapCamera = MKMapCamera()
            mapCamera.pitch = 10
            mapCamera.altitude = 3000
            mapView.camera = mapCamera
            
            mapView.showAnnotations(annotations, animated: true)
            
            if let first = annotations.first {
                mapCamera.centerCoordinate = first.coordinate
                mapView.camera = mapCamera
            } else {
                let coordinate = CLLocationCoordinate2D(latitude: 37.51786, longitude: 126.88643)
                mapView.camera.centerCoordinate = coordinate
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var mapView: MKMapView?
        var locationManager: CLLocationManager?
        
        init(parent: MapView) {
            self.parent = parent
            super.init()
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? CustomAnnotation {
                let cameraPosition = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - 0.003, longitude: annotation.coordinate.longitude)
                let camera = MKMapCamera(lookingAtCenter: cameraPosition, fromDistance: 2000, pitch: 0, heading: 0)
                mapView.setCamera(camera, animated: true)
                parent.selectAction?(annotation.placeInfo)
                parent.isSelected = true
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? CustomAnnotation {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
                view.displayPriority = .required
                view.glyphImage = UIImage(systemName: "star.fill")
                view.selectedGlyphImage = UIImage(systemName: "star.fill")
                view.markerTintColor = .mainApp
                view.glyphTintColor = .mainAppConvert
                
                return view
            }
            
            return nil
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
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        Task { @MainActor in
            self.mapView?.setRegion(region, animated: true)
            self.locationManager?.stopUpdatingLocation()
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
