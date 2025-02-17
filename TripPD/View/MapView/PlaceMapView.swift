//
//  PlaceMapView.swift
//  TripPD
//
//  Created by 김상규 on 10/21/24.
//

import SwiftUI
import MapKit

struct PlaceMapView: UIViewRepresentable {
    var places: [PlaceForView]
    var annotations: [PlaceMapAnnotation]
    var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var selectedPlace: PlaceForView?
    @Binding var setRegion: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        setInitialRegion(mapView: mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(mapView: uiView)
        updateOverlays(mapView: uiView)
        updateCamera(mapView: uiView)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: PlaceMapView
        var mapView: MKMapView?
        
        init(parent: PlaceMapView) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? PlaceMapAnnotation {
                let view = PlaceMapAnnotationViewController(annotation: annotation, places: parent.places, reuseIdentifier: PlaceMapAnnotationViewController.identifier)
                
                return view
            }
            return nil
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.mainApp
                renderer.lineWidth = 2.5
                renderer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
                renderer.lineJoin = .round
                renderer.lineCap = .round
                
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

extension PlaceMapView {
    private func updateAnnotations(mapView: MKMapView) {
        if !mapView.annotations.elementsEqual(annotations, by: { $0.coordinate.latitude == $1.coordinate.latitude && $0.coordinate.longitude == $1.coordinate.longitude }) {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
        }
    }
    
    private func updateOverlays(mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        if !routeCoordinates.isEmpty {
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)
        }
    }
    
    private func updateCamera(mapView: MKMapView) {
        if setRegion {
            Task { @MainActor in
                setInitialRegion(mapView: mapView)
                self.setRegion = false
            }
        } else if let selectedPlace = selectedPlace {
            let currentCoord = mapView.camera.centerCoordinate
            let targetCoord = CLLocationCoordinate2D(latitude: selectedPlace.lat, longitude: selectedPlace.lon)
            
            if abs(currentCoord.latitude - targetCoord.latitude) > 0.0001 ||
               abs(currentCoord.longitude - targetCoord.longitude) > 0.0001 {
                let camera = MKMapCamera(lookingAtCenter: targetCoord, fromDistance: 1000, pitch: 0, heading: 0)
                mapView.setCamera(camera, animated: true)
            }
        }
    }
    
    private func setInitialRegion(mapView: MKMapView) {
        let firstCoordinate = annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        let firstAnnotationPoint = MKMapPoint(firstCoordinate)
        
        if annotations.count == 1 {
            let camera = MKMapCamera(lookingAtCenter: firstAnnotationPoint.coordinate, fromDistance: 1000, pitch: 0, heading: 0)
            
            UIView.animate(withDuration: 0.5) {
                mapView.setCamera(camera, animated: false)
            }
        } else {
            var zoomRect = MKMapRect(x: firstAnnotationPoint.x, y: firstAnnotationPoint.y, width: 0.01, height: 0.01)
            
            for annotation in annotations.dropFirst() {
                let point = MKMapPoint(annotation.coordinate)
                let rect = MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(rect)
            }
            
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
}

final class PlaceMapAnnotation: NSObject, MKAnnotation {
    let id: String
    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(place: PlaceForView) {
        self.id = place.id
        self.title = place.name
        self.coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
    }
}

class PlaceMapAnnotationViewController: MKAnnotationView {
    
    static var identifier: String {
        String(describing: self)
    }
    
    private var hostingController: UIHostingController<PlaceMapAnnotationView>?
    
    init(annotation: PlaceMapAnnotation, places: [PlaceForView], reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let mapAnnotationView = PlaceMapAnnotationView(annotation: annotation, places: places)
        let hostingController = UIHostingController(rootView: mapAnnotationView)
        
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15)
        ])
        
        hostingController.view.backgroundColor = .clear
        
        self.hostingController = hostingController
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

struct PlaceMapAnnotationView: View {
    var annotation: PlaceMapAnnotation
    var places: [PlaceForView]
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.mainApp, lineWidth: 1)
                    .background(.mainApp)
                    .frame(height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text(annotation.title ?? "")
                    .foregroundStyle(.background)
                    .font(.appFont(12))
                    .padding(.horizontal, 5)
            }
            .shadow(color: .gray.opacity(0.5), radius: 0.7)
            
            Circle()
                .fill(.mainApp)
                .overlay {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.background, .mainApp)
                }
                .frame(width: 30, height: 30)
        }
        .padding(.bottom, 5)
        .shadow(color: .gray.opacity(0.5), radius: 0.7)
    }
}
