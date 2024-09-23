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
    var type: MapType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        
        switch type {
        case .myAround:
            break
        case .addPlace:
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tapLocation(_:)))
            mapView.addGestureRecognizer(tapGesture)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations) // Remove existing annotations
        uiView.addAnnotations(annotations)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
        }
    }
}

extension MapView.Coordinator {
    @objc func tapLocation(_ gesture: UITapGestureRecognizer) {
        let geocoder = CLGeocoder()
        let location = gesture.location(in: gesture.view)
        let coordinate = (gesture.view as! MKMapView).convert(location, toCoordinateFrom: gesture.view)
        
        convertGeocoder(coordinate) { value in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = value
            
            self.parent.annotations.removeAll()
            self.parent.annotations.append(annotation)
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
