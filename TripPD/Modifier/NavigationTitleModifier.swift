//
//  NavigationTitleFontModifier.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI

extension View {
    func navigationBarTitle(_ inlineFontSize: CGFloat, _ largeFontSize: CGFloat) -> some View {
        return self.modifier(NavigationTitleModifier(inlineFontSize: inlineFontSize, largeFontSize: largeFontSize))
    }
}

struct NavigationTitleModifier: ViewModifier {
    var inlineFontSize: CGFloat
    var largeFontSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let fontAppearance = UINavigationBarAppearance()
                fontAppearance.titleTextAttributes = [.font: UIFont.appFont(inlineFontSize), .foregroundColor: UIColor.mainApp]
                fontAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(largeFontSize), .foregroundColor: UIColor.mainApp]
                
                UINavigationBar.appearance().standardAppearance = fontAppearance
                UINavigationBar.appearance().compactAppearance = fontAppearance
                UINavigationBar.appearance().prefersLargeTitles = true
                UINavigationBar.appearance().isHidden = false
            }
    }
}
