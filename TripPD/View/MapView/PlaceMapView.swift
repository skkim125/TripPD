//
//  PlaceMapView.swift
//  TripPD
//
//  Created by 김상규 on 10/21/24.
//

import SwiftUI
import MapKit

struct PlaceMapView: UIViewRepresentable {
    @Binding var places: [PlaceForView]
    @Binding var annotations: [PlaceMapAnnotation]
    @Binding var selectedPlace: PlaceForView?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        mapView.delegate = context.coordinator
        
        context.coordinator.mapView = mapView
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        DispatchQueue.main.async {
            let firstAnnotationPoint = MKMapPoint(annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            var zoomRect = MKMapRect(x: firstAnnotationPoint.x, y: firstAnnotationPoint.y, width: 0.01, height: 0.01)
            
            for annotation in annotations.dropFirst() {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(pointRect)
            }
            
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: false)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard let place = selectedPlace else {
            
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
            
            let firstAnnotationPoint = MKMapPoint(annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            var zoomRect = MKMapRect(x: firstAnnotationPoint.x, y: firstAnnotationPoint.y, width: 0.01, height: 0.01)
            
            for annotation in annotations.dropFirst() {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
                zoomRect = zoomRect.union(pointRect)
            }
            
            uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: false)
            
            return
        }
        
        let coord = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
        
        let cameraPostion = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        let camera = MKMapCamera(lookingAtCenter: cameraPostion, fromDistance: 1000, pitch: 0, heading: 0)
        
        UIView.animate(withDuration: 0.5) {
            uiView.setCamera(camera, animated: false)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: PlaceMapView
        var mapView: MKMapView?
        
        init(parent: PlaceMapView) {
            self.parent = parent
            
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? PlaceMapAnnotation {
                let view = PlaceMapAnnotationViewController(annotation: annotation, places: parent.places, reuseIdentifier: PlaceMapAnnotationViewController.identifier)
                
                let annotationView = self.mapView?.dequeueReusableAnnotationView(withIdentifier: PlaceMapAnnotationViewController.identifier)
                annotationView?.annotation = annotation
                
                return view
            }
            
            return nil
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
            hostingController.view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        hostingController.view.layer.cornerRadius = 5
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
            
            var index: Int? {
                return places.sorted(by: { $0.time < $1.time }).firstIndex(where: { $0.id == annotation.id })
            }
            
            Circle()
                .fill(.mainApp)
                .overlay {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.background, .mainApp)
                }
                .frame(width: 25, height: 25)
        }
        .padding(.bottom, 5)
        .shadow(color: .gray, radius: 0.7)
    }
    
}
