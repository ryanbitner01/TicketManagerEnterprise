//
//  BounceAnimation.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/23/22.
//

import Foundation
import UIKit

extension UIView {
    func bounceAnimation(repeatCount: Int = 0) {
        let size = 1.5
        for _ in 0...repeatCount {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: []) {
                self.transform = CGAffineTransform(scaleX: size, y: size)
            } completion: { finished in
                if finished {
                    self.transform = .identity
                }
            }

        }
        
        
    }
}
