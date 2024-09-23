//
//  KeyboardNotificationManager.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI

final class KeyboardNotificationManager {
    static let shared = KeyboardNotificationManager()
    private init() { }
    
    func keyboardNoti(_ showHandler: @escaping (CGFloat) -> Void,  hideHandler: @escaping (CGFloat) -> Void) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            
            if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                
                showHandler(keyboardSize.height)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            
            hideHandler(0)
        }
    }
    
    func removeNotiObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
