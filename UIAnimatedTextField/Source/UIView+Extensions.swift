//
//  UIView+Extensions.swift
//  Pods
//
//  Created by Ivan Zinovyev on 12/19/16.
//
//

import UIKit

extension UIView {
    
    func addSubviewCentered(view: UIView) {
        var viewFrame = view.frame
        viewFrame.origin.x = (frame.width - viewFrame.width) / 2
        viewFrame.origin.y = (frame.height - viewFrame.height) / 2
        view.frame = viewFrame
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        addSubview(view)
    }
    
    class var onePixelInPoints: CGFloat {
        return 1.0 / UIScreen.main.scale
    }
    
    var allSubviews: [UIView] {
        let allSubviews = subviews + subviews.flatMap { $0.allSubviews }
        return allSubviews
    }
    
    func viewFromSelfDescribingNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
}
