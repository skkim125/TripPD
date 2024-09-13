//
//  LazyWrapperView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI

struct LazyWrapperView<Content: View>: View {
    
    let closure: () -> Content
    
    var body: some View {
        closure()
    }
    
    init(_ closure: @autoclosure @escaping () -> Content) {
        self.closure = closure
        
        print("NavigationLazyView init")
    }
}
