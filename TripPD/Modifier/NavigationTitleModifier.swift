//
//  NavigationTitleFontModifier.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI

extension View {
    func navigationBarTitleColor(_ color: UIColor) -> some View {
        return self.modifier(NavigationTitleModifier(color: color))
    }
}

struct NavigationTitleModifier: ViewModifier {
    var color: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let fontAppearance = UINavigationBarAppearance()
                fontAppearance.titleTextAttributes = [.font: UIFont.appFont(20), .foregroundColor: color]
                fontAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(20), .foregroundColor: color]
                
                UINavigationBar.appearance().standardAppearance = fontAppearance
            }
    }
}
