//
//  DesignResource.swift
//  TripPD
//
//  Created by 김상규 on 9/14/24.
//

import SwiftUI

extension UIFont {
    static func appFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OTJalpullineunoneulM", size: size)!
    }
}

extension Font {
    static func appFont(_ size: CGFloat) -> Font {
        return .custom("OTJalpullineunoneulM", size: size)
    }
}
