//
//  View+RoundedCorners.swift
//
//  Created by Rodrigo Galvez on 29/04/23.
//

import SwiftUI

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
