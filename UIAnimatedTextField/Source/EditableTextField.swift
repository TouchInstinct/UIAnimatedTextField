//
//  EditableTextField.swift
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

import Foundation

public class EditableTextField: UITextField {
    
    var getType: (() -> TextType?)?
    
    private let menuSelectors = [
        #selector(selectAll(_:)),
        #selector(select(_:)),
        #selector(cut(_:)),
        #selector(copy(_:)),
        #selector(paste(_:))
    ]
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let type = getType?() else {
            return super.canPerformAction(action, withSender: sender)
        }
        
        if case .date = type {
            if menuSelectors.contains(action) {
                return false
            }
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    override public func caretRect(for position: UITextPosition) -> CGRect {
        guard let type = getType?() else {
            return super.caretRect(for: position)
        }
        
        if case .date = type {
            return CGRect.null
        }
        
        return super.caretRect(for: position)
    }
    
}
