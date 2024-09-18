//
//  View+Extension.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
