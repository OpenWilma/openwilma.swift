//
//  ColorUtils.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.1.2023.
//

import Foundation
import SwiftUI

struct ColorUtils {
    static func hexStringFromColor(_ color: Color) -> String {
        let components = color.cgColor!.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
     }
}
