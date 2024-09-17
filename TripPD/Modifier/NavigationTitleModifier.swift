//
//  NavigationTitleFontModifier.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI

extension View {
    func navigationBarTitle(_ color: UIColor, _ fontSize: CGFloat) -> some View {
        return self.modifier(NavigationTitleModifier(color: color, fontSize: fontSize))
    }
}

struct NavigationTitleModifier: ViewModifier {
    var color: UIColor
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let fontAppearance = UINavigationBarAppearance()
                fontAppearance.titleTextAttributes = [.font: UIFont.appFont(fontSize), .foregroundColor: color]
                fontAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(fontSize), .foregroundColor: color]
                
                UINavigationBar.appearance().standardAppearance = fontAppearance
            }
    }
}
