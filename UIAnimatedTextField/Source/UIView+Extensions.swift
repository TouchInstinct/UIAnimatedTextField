//
//  UIView+Extensions.swift
//
//  Copyright (c) 2016 Touch Instinct
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
