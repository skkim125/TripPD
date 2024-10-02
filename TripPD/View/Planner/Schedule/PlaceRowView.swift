//
//  PlaceRowView.swift
//  TripPD
//
//  Created by 김상규 on 9/26/24.
//

import SwiftUI
import MapKit

struct PlaceRowView: View {
    var schedule: ScheduleForView
    var place: PlaceForView
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .center) {
                Text("\(place.time.customDateFormatter(.onlyTime))")
                    .font(.appFont(10))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                
                Circle()
                    .fill(.mainApp)
                    .frame(width: 15, height: 15)
                    .padding(3)
                    .background(.white.shadow(.drop(color: .appBlack.opacity(0.2), radius: 3)), in: .circle)
                
                times(place: place)
                    .padding(.top, -8)
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.mainApp)
                .shadow(radius: 3)
                .overlay {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), annotationItems: [Location(name: place.name, coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon))]) { value in
                        
                        MapAnnotation(coordinate: value.coordinate) {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.mainApp, lineWidth: 1)
                                        .background(.mainApp)
                                        .frame(height: 25)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .shadow(radius: 3)
                                    
                                    Text("\(value.name)")
                                        .foregroundStyle(.background)
                                        .font(.appFont(12))
                                        .padding(.horizontal, 5)
                                }
                                
                                Circle()
                                    .stroke(.mainApp)
                                    .overlay {
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.background, .mainApp)
                                    }
                                    .frame(width: 25, height: 25)
                                    .shadow(radius: 3)
                            }
                            .padding(.bottom, 5)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.all, 7)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 100)
                .disabled(true)
                .padding(.top, 5)
        }
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    private func times(place: PlaceForView) -> some View {
        if schedule.places.sorted(by: { $0.time < $1.time }).last?.id != place.id {
            HStack {
                Rectangle()
                    .fill(.mainApp)
                    .frame(width: 2, height: 70)
            }
        } else {
            HStack {
                Text("End")
                    .font(.appFont(14))
                    .foregroundStyle(.mainApp)
                    .padding(.top, 5)
            }
        }
    }
}

//#Preview {
//    PlaceRowView()
//}
