//
//  UserView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import MessageUI

struct UserView: View {
    @State private var isOpenMailSheet = false
    @State private var isOpenPastTrip = false
    @State private var isOpenAppInfo = false
    @AppStorage("AppDarkMode") private var appStyleRawValue: String = AppDarkMode.system.rawValue
    private var selectedDarkMode: AppDarkMode {
        AppDarkMode(rawValue: appStyleRawValue) ?? .system
    }
    
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationStack {
            List(Settings.allCases, id: \.self) { item in
                Button {
                    switch item {
                    case .pastTrip:
                        isOpenPastTrip.toggle()
                    case .inquiry:
                        EmailController.shared.sendEmail(subject: "제목을 입력해주세요", body: "문의 내용을 입력해주세요", to: "kthanks125@gmail.com")
                    case .appInfo:
                        isOpenAppInfo.toggle()
                    default:
                        break
                    }
                } label: {
                    settingRowView(item)
                }
            }
            .navigationDestination(isPresented: $isOpenPastTrip){
                PastTravelView()
                    .onAppear {
                        hideTabBar = true
                    }
                    .onDisappear {
                        hideTabBar = false
                    }
            }
            .navigationDestination(isPresented: $isOpenAppInfo){
                AppInfoView()
                    .onAppear {
                        hideTabBar = true
                    }
                    .onDisappear {
                        hideTabBar = false
                    }
            }
            .navigationBarTitle(20, 30)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    @ViewBuilder
    func settingRowView(_ setting: Settings) -> some View {
        
        HStack {
            Text("\(setting.rawValue)")
                .font(.appFont(15))
            
            Spacer()
            
            if setting == .appStyle {
                Menu {
                    ForEach(AppDarkMode.allCases, id: \.self) { style in
                        Button {
                            appStyleRawValue = style.rawValue
                        } label: {
                            Label(style.rawValue, systemImage: selectedDarkMode == style ? "checkmark.circle.fill" : "circle")
                        }
                    }
                } label: {
                    HStack {
                        Text("\(selectedDarkMode.rawValue)")
                            .font(.appFont(15))
                    }
                }
            } else {
                Image(systemName: "chevron.forward")
                    .font(.appFont(15))
                    .foregroundStyle(.mainApp)
            }
        }
        .foregroundStyle(.mainApp)
    }
}

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    private override init() { }
    
    func sendEmail(subject: String, body: String, to: String) {
        if !MFMailComposeViewController.canSendMail() {
            print("메일 앱이 없어 보낼 수 없음")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
}

enum Settings: String, CaseIterable {
    case pastTrip = "지나간 여행 보기"
    case appStyle = "앱 스타일"
    case inquiry = "개발자에게 문의하기"
    case appInfo = "앱 정보"
}

#Preview {
    UserView(hideTabBar: .constant(false))
}
