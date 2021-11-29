//
//  UIViewExtension.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 26.11.21.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
