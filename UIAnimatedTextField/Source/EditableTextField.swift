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

public enum EditableActionType {
    case selectAll
    case select
    case cut
    case copy
    case paste

    public static let allActions = [EditableActionType.selectAll, .select, .cut, .paste, .copy]
}

open class EditableTextField: UITextField {

    /// Actions, that will be disabled for this textField.
    /// By default no actions are disabled.
    open var disabledActions: [EditableActionType] = []

    /// Allows to disable moving cursor for user
    open var pinCursorToEnd: Bool = false

    open var getType: (() -> TextType?)?

    // MARK: - Private

    private var disabledSelectors: [Selector] {
        return disabledActions.map { selector(from: $0) }
    }

    private let menuSelectors = [
        #selector(selectAll(_:)),
        #selector(select(_:)),
        #selector(cut(_:)),
        #selector(copy(_:)),
        #selector(paste(_:))
    ]

    // MARK: - Overriden
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if disabledSelectors.contains(action) {
            return false
        }

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
    
    override open func caretRect(for position: UITextPosition) -> CGRect {
        guard let type = getType?() else {
            return super.caretRect(for: position)
        }
        
        if case .date = type {
            return CGRect.null
        }
        
        return super.caretRect(for: position)
    }

    override open func closestPosition(to point: CGPoint) -> UITextPosition? {
        if pinCursorToEnd {
            return endOfDocument
        }

        return super.closestPosition(to: point)
    }
    
}

// MARK: - Private extensions

private extension UITextField {

    func selector(from actionTyoe: EditableActionType) -> Selector {
        switch actionTyoe {
        case .selectAll:
            return #selector(selectAll(_:))
        case .select:
            return #selector(select(_:))
        case .cut:
            return #selector(cut(_:))
        case .copy:
            return #selector(copy(_:))
        case .paste:
            return #selector(paste(_:))
        }
    }
}
