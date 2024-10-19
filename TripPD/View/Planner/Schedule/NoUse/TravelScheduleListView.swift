//
//  TravelScheduleListView.swift
//  TripPD
//
//  Created by 김상규 on 9/18/24.
//

//import SwiftUI
//import RealmSwift

//struct TravelScheduleListView: View {
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject private var viewModel: TravelScheduleListViewModel
//    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//    
//    init(travel: TravelForView) {
//        
//        self.viewModel = TravelScheduleListViewModel(travel: travel)
//        
//        let fontAppearance = UINavigationBarAppearance()
//        fontAppearance.titleTextAttributes = [.font: UIFont.appFont(20), .foregroundColor: UIColor.mainApp]
//        fontAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(30), .foregroundColor: UIColor.mainApp]
//        
//        let navBar = UINavigationBar.appearance()
//        navBar.standardAppearance = fontAppearance
//        navBar.prefersLargeTitles = true
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.travel.schedules, id: \.id) { schedule in
//                        NavigationLink {
//                            PlanningScheduleView(schedule: schedule)
//                        } label: {
//                            scheduleRow(schedule.day.customDateFormatter(.scheduleViewMonth), schedule.day.customDateFormatter(.scheduleViewDay))
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 5)
//                        
//                    }
//                }
//                .padding(.init(top: 5, leading: 15, bottom: 0, trailing: 15))
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        Button(role: .destructive) {
//                            viewModel.action(action: .showDeleteAlert)
//                        } label: {
//                            Text("여행 삭제")
//                            Image(systemName: "trash")
//                        }
//                        
//                    } label: {
//                        Image(systemName: "ellipsis")
//                    }
//                    .tint(.mainApp)
//                    
//                }
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.backward")
//                            .foregroundStyle(.mainApp.gradient)
//                            .bold()
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $viewModel.showDeleteAlert) {
//            Alert(title: Text("정말로 여행 플랜을 삭제하시겠습니까?"), message: Text("삭제 이후 복구할 수 없습니다."), primaryButton: .cancel(Text("아니요")), secondaryButton: .destructive(Text("예"), action: {
//                viewModel.action(action: .deleteAction)
//                dismiss()
//            }))
//        }
//        .navigationTitle("\(viewModel.travel.title)")
//        .navigationBarTitleDisplayMode(.large)
//        .navigationBarTitle(20, 30)
//        .navigationBarBackButtonHidden()
//    }
//    
//    func scheduleRow(_ month: String, _ day: String) -> some View {
//        VStack {
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(.mainApp.gradient , lineWidth: 3)
//                .frame(width: 110, height: 130)
//                .overlay {
//                    VStack {
//                        Rectangle()
//                            .fill(.mainApp.gradient)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 40)
//                            .overlay {
//                                Text("\(month)")
//                                    .font(.appFont(20))
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .foregroundStyle(.ultraThickMaterial)
//                            }
//                        
//                        Spacer()
//                        
//                        Text("\(day)")
//                            .font(.appFont(40))
//                            .foregroundStyle(.mainApp.gradient)
//                        
//                        Spacer()
//                    }
//                }
//                .background(.clear)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//        }
//    }
//}

//#Preview {
//    TravelScheduleListView(travel: Travel())
//}
