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
    @Binding var selectedPlace: PlaceForView
    var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var setRegion: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        setRegion(mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !uiView.annotations.elementsEqual(annotations, by: { $0.coordinate.latitude == $1.coordinate.latitude && $0.coordinate.longitude == $1.coordinate.longitude }) {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
        
        uiView.removeOverlays(uiView.overlays)
        if !routeCoordinates.isEmpty {
            let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
            uiView.addOverlay(polyline)
        }
        
        if setRegion {
            DispatchQueue.main.async {
                setRegion(uiView)
                self.setRegion = false
            }
        } else if !selectedPlace.id.isEmpty {
            let currentCoord = uiView.camera.centerCoordinate
            let targetCoord = CLLocationCoordinate2D(latitude: selectedPlace.lat, longitude: selectedPlace.lon)

            if abs(currentCoord.latitude - targetCoord.latitude) > 0.0001 ||
               abs(currentCoord.longitude - targetCoord.longitude) > 0.0001 {
                let camera = MKMapCamera(lookingAtCenter: targetCoord, fromDistance: 1000, pitch: 0, heading: 0)
                uiView.setCamera(camera, animated: true)
            }
        }
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
                renderer.lineWidth = 3
                renderer.lineDashPattern = [NSNumber(value: 10), NSNumber(value: 5)]
                       
                renderer.lineJoin = .round
                renderer.lineCap = .round
                
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

extension PlaceMapView {
    private func setRegion(_ view: MKMapView) {
        
        let firstAnnotationPoint = MKMapPoint(annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        
        if annotations.count == 1 {
            let camera = MKMapCamera(lookingAtCenter: firstAnnotationPoint.coordinate, fromDistance: 1000, pitch: 0, heading: 0)
            
            UIView.animate(withDuration: 0.5) {
                view.setCamera(camera, animated: false)
            }
        } else {
            
            var zoomRect = MKMapRect(x: firstAnnotationPoint.x, y: firstAnnotationPoint.y, width: 0.01, height: 0.01)
            
            for annotation in annotations.dropFirst() {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(pointRect)
            }
            
            DispatchQueue.main.async {
                view.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
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
        let customSwiftUIView = PlaceMapAnnotationView(annotation: annotation, places: places)
        let hostingController = UIHostingController(rootView: customSwiftUIView)
        
        addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
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
                
                Text("\(annotation.title ?? "")")
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
