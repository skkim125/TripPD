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
                mapCamera.centerCoordinate = coordinate
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
            locationManager?.requestWhenInUseAuthorization()
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
        guard let location = locations.last else { return }
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

enum MapType {
    case myAround
    case addPlace
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
