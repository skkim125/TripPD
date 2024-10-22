//
//  PlaceLocationView.swift
//  TripPD
//
//  Created by 김상규 on 9/26/24.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let placeId: String
    let name: String
    let coordinate: CLLocationCoordinate2D
}

//struct PlaceLocationView: View {
//    @Binding var coord: MKCoordinateRegion
//    var annotation: Location
//    
//    var body: some View {
//        Map(coordinateRegion: $coord, annotationItems: [annotation]) { value in
//            MapAnnotation(coordinate: value.coordinate) {
//                
//            }
//        }
//    }
//}

//#Preview {
//    PlaceLocationView(coord: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan())), annotation: CustomAnnotation(placeInfo: <#T##PlaceInfo#>))
//}
