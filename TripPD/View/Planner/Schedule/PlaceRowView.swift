//
//  PlaceRowView.swift
//  TripPD
//
//  Created by 김상규 on 9/26/24.
//

import SwiftUI
import MapKit

struct PlaceRowView: View {
    var schedule: Schedule
    var place: Place
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text("\(place.time.customDateFormatter(.onlyTime))")
                    .font(.appFont(10))
                    .foregroundStyle(.gray)
                
                Circle()
                    .fill(.mainApp)
                    .frame(width: 15, height: 15)
                    .padding(3)
                    .background(.white.shadow(.drop(color: .appBlack.opacity(0.2), radius: 3)), in: .circle)
                
                times(place: place)
            }
            .padding(.leading, 15)
            
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.mainApp)
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
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.all, 10)
                    }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(.trailing, 15)
            .disabled(true)
            .shadow(radius: 3)
        }
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func times(place: Place) -> some View {
        if schedule.places.last?.id != place.id {
            VStack {
                
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(.mainApp)
                            .frame(width: 2, height: 70)
                    }
                    .offset(x: 24)
                    
                    Spacer()
                }
                
                Spacer()
            }
        } else {
            VStack {
                HStack {
                    Text("End")
                        .font(.appFont(14))
                        .foregroundStyle(.mainApp)
                        .offset(x: 15)
                        .padding(.top, 3)
                    
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    PlaceRowView()
//}
