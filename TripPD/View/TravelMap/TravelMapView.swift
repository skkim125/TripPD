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
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State private var annotations: [CustomAnnotation] = []
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                MapView(annotations: $annotations, showAlert: $showAlert, isSearched: .constant(false), isSelected: .constant(false), type: .myAround, selectAction: nil)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("위치 권한 필요"),
                            message: Text("위치 권한이 필요합니다. 설정에서 권한을 허용해주세요."),
                            primaryButton: .default(Text("설정으로 이동"), action: {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    DispatchQueue.main.async {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }),
                            secondaryButton: .cancel(Text("닫기"))
                        )
                    }
                
            }
            .navigationBarTitle(20, 30)
            .navigationTitle("내 주변 장소")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

#Preview {
    TravelMapView()
}
