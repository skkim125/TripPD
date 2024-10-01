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
    var type: MapType
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
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        DispatchQueue.main.async {
            if isSearched {
                uiView.removeAnnotations(uiView.annotations)
                uiView.addAnnotations(annotations)
                
                if !annotations.isEmpty {
                    var zoomRect = MKMapRect.null
                    
                    if isSelected {
                        if let selectedAnnotation = self.selectedAnnotation {
                            withAnimation {
                                uiView.camera.centerCoordinate = selectedAnnotation.coordinate
                            }
                            
                            isSelected = false
                        }
                    } else {
                        for annotation in annotations {
                            let annotationPoint = MKMapPoint(annotation.coordinate)
                            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                            zoomRect = zoomRect.union(pointRect)
                        }
                        
                        uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                    }
                }
            } else {
                if let locationManager = context.coordinator.locationManager, locationManager.authorizationStatus == .denied {
                    self.showAlert = true
                    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.51786, longitude: 126.88643)
                    let mapCamera = MKMapCamera(lookingAtCenter: defaultCoordinate, fromDistance: 3000, pitch: 10, heading: 0)
                    uiView.camera = mapCamera
                } else {
                    let mapCamera = MKMapCamera()
                    mapCamera.pitch = 10
                    mapCamera.altitude = 3000
                    uiView.camera = mapCamera
                    
                    uiView.showAnnotations(annotations, animated: true)
                    
                    if let first = annotations.first {
                        DispatchQueue.main.async {
                            let coordinate = first.coordinate
                            mapCamera.centerCoordinate = coordinate
                            uiView.camera = mapCamera
                        }
                    } else {
                        let coordinate = CLLocationCoordinate2D(latitude: 37.51786, longitude: 126.88643)
                        uiView.camera.centerCoordinate = coordinate
                    }
                }
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
                let cameraPostion = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - 0.003, longitude: annotation.coordinate.longitude)
                
                
                let camera = MKMapCamera(lookingAtCenter: cameraPostion, fromDistance: 2000, pitch: 0, heading: 0)
                mapView.setCamera(camera, animated: true)
                parent.selectAction?(annotation.placeInfo)
                parent.isSelected = true
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? CustomAnnotation {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceMarker")
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
        
        DispatchQueue.main.async {
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted, .denied:
                DispatchQueue.main.async {
                    self.parent.showAlert = true
                }
            case .authorizedWhenInUse, .authorizedAlways:
                DispatchQueue.main.async {
                    manager.startUpdatingLocation()
                }
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
        
        DispatchQueue.main.async {
            self.mapView?.setRegion(region, animated: true)
            
            self.locationManager?.stopUpdatingLocation()
        }
    }
}

enum MapType {
    case myAround
    case addPlace
    case placeInfo
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
