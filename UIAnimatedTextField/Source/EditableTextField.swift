//
//  EditableTextField.swift
//  Pods
//
//  Created by Ivan Zinovyev on 12/19/16.
//
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
