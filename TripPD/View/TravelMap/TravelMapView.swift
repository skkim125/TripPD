//
//  TravelMapView.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI
import MapKit

struct Annotation: Identifiable {
    let id = UUID()
    let name: String
    let coord: CLLocationCoordinate2D
}

struct TravelMapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 3000, longitudinalMeters: 3000)
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [MKPointAnnotation] = []
    
    
    var body: some View {
        NavigationStack {
            VStack {
                MapView(annotations: $annotations, type: .myAround)
                    .edgesIgnoringSafeArea(.all)
                
                if !annotations.isEmpty {
                    Text("마커 개수: \(annotations.count)")
                }
            }
            .navigationBarTitle(20, 30)
            .navigationTitle("내 주변 장소")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    // 좌표 변환 함수
    private func convertToMapCoordinate(location: CGPoint, mapSize: CGSize) -> CLLocationCoordinate2D {
        let mapCenter = mapRegion.center
        let span = mapRegion.span
        
        // X, Y 좌표를 위도와 경도로 변환
        let longitude = mapCenter.longitude + (Double(location.x / mapSize.width) - 0.5) * span.longitudeDelta
        let latitude = mapCenter.latitude - (Double(location.y / mapSize.height) - 0.5) * span.latitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    TravelMapView()
}
