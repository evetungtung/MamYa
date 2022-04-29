//
//  Extension.swift
//  MamYa
//
//  Created by Evelin Evelin on 26/04/22.
//

import UIKit

extension UIImageView {
    
    func addoverlay(color: UIColor = .black,alpha : CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}

//extension UIButton {
//    @IBInspectable var cornerRadiusBtn: CGFloat {
//        get {return cornerRadius}
//        set{
//            self.layer.cornerRadius = newValue
//        }
//    }
//}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{ return cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 16
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
