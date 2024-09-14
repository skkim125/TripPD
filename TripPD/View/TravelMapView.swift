//
//  TravelMapView.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coord: CLLocationCoordinate2D
}

struct TravelMapView: View {
    @State private var centerX = 0.0
    @State private var centerY = 0.0
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 1000, longitudinalMeters: 1000)
    @State private var locations: [Location] = [
        Location(name: "새싹", coord: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463))
    
    ]
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coord) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.subColor2, lineWidth: 1)
                        .background(.mainApp)
                        .frame(height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text("\(location.name)")
                        .foregroundStyle(.subColor2)
                        .font(.subheadline)
                        .padding(.horizontal, 5)
                }
                
                Circle()
                    .stroke(.subColor2)
                    .overlay {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.subColor2, .mainApp)
                    }
                    .frame(width: 25, height: 25)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    TravelMapView()
}
