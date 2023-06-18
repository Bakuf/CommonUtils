//
//  UIView+Extensions.swift
//  
//
//  Created by Rodrigo Galvez on 18/06/2023.
//

import UIKit

public extension UIView {
    
    func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func addSubviewWithBorderLayout(subView: UIView) {
        addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subView.topAnchor.constraint(equalTo: self.topAnchor),
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func removeSubviewsWith(tag: Int) {
        subviews.forEach { v in
            if v.tag == tag { v.removeFromSuperview() }
        }
    }
    
    func subviewWith(tag: Int) -> UIView? {
        subviews.first(where: { $0.tag == tag })
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}
