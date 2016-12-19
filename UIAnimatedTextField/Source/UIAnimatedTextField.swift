//
//  UIAnimatedTextField.swift
//  Pods
//
//  Created by Ivan Zinovyev on 12/19/16.
//
//

import UIKit

@objc protocol UIAnimatedTextFieldDelegate: class {
    
    @objc optional func animatedTextFieldValueDidChange(_ animatedTextField: UIAnimatedTextField)
    @objc optional func animatedTextFieldWillReactForTap()
    @objc optional func animatedTextFieldShouldBeginEditing(_ animatedTextField: UIAnimatedTextField) -> Bool
    @objc optional func animatedTextFieldDidBeginEditing(_ animatedTextField: UIAnimatedTextField)
    @objc optional func animatedTextFieldShouldEndEditing(_ animatedTextField: UIAnimatedTextField) -> Bool
    @objc optional func animatedTextFieldDidEndEditing(_ animatedTextField: UIAnimatedTextField)
    @objc optional func animatedTextField(_ animatedTextField: UIAnimatedTextField,
                                          shouldChangeCharactersInRange range: NSRange,
                                          replacementString string: String) -> Bool
    @objc optional func animatedTextFieldShouldClear(_ animatedTextField: UIAnimatedTextField) -> Bool
    @objc optional func animatedTextFieldShouldReturn(_ animatedTextField: UIAnimatedTextField) -> Bool
    
}

enum AnimatedTextFieldState {
    case placeholder
    case text
}

enum TextType {
    case simple
    case password
    case url
    case tappable(action: (_ animatedTextField: UIAnimatedTextField) -> Void)
    case date
}

@IBDesignable
public class UIAnimatedTextField: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: UIAnimatedTextFieldDelegate?
    
    // MARK: - UI Properties
    
    private(set) var textField: EditableTextField!
    private(set) var placeholderLabel: UILabel!
    
    private(set) var lineView: UIView!
    private var disclosureIndicatorImageView: UIImageView!
    
    // MARK: - Properties
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            delegate?.animatedTextFieldValueDidChange?(self)
            layoutSubviews()
        }
    }
    
    @IBInspectable var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    
    var font: UIFont? {
        get {
            return placeholderLabel.font
        }
        set {
            textField.font = newValue
            placeholderLabel.font = newValue
        }
    }
    
    var isDisclosureIndicatorVisible: Bool = false {
        didSet {
            disclosureIndicatorImageView.isHidden = !isDisclosureIndicatorVisible
        }
    }
    
    @IBInspectable var isLeftTextAlignment: Bool {
        get {
            return textField.textAlignment == .left
        }
        set {
            let alignment: NSTextAlignment = newValue ? .left : .center
            textField.textAlignment = alignment
            placeholderLabel.textAlignment = alignment
        }
    }
    
    var type: TextType = .simple {
        didSet {
            textField.isSecureTextEntry = false
            textField.keyboardType = .default
            textField.isUserInteractionEnabled = true
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .words
            textField.inputView = nil
            textField.inputAccessoryView = nil
            
            tapAction = nil
            isDisclosureIndicatorVisible = false
            
            if let tapGestureRecognizer = tapGestureRecognizer {
                removeGestureRecognizer(tapGestureRecognizer)
                self.tapGestureRecognizer = nil
            }
            
            switch type {
            case .password:
                textField.isSecureTextEntry = true
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
            case .url:
                textField.keyboardType = .emailAddress
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
            case .tappable(let action):
                tapAction = action
                textField.isUserInteractionEnabled = false
                isDisclosureIndicatorVisible = true
                
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:)))
                if let tapGestureRecognizer = tapGestureRecognizer {
                    addGestureRecognizer(tapGestureRecognizer)
                }
            case .date:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.inputView = getDateInputView()
                textField.inputAccessoryView = getDateInputAccessoryView()
            default:
                break
            }
        }
    }
    
    var selectedDate: Date?
    
    @IBInspectable var placeholderTopColor: UIColor = UIColor.gray
    @IBInspectable var placeholderBottomColor: UIColor = UIColor.gray
    
    @IBInspectable var enteredTextColor: UIColor {
        get { return textField.textColor ?? UIColor.black }
        set { textField.textColor = newValue }
    }
    
    @IBInspectable var lineColor: UIColor {
        get { return lineView.backgroundColor ?? UIColor.gray }
        set { lineView.backgroundColor = newValue }
    }
    
    // MARK: - Private Properties
    
    static let animationDuration: TimeInterval = 0.3
    static let disclosureIndicatorWidth = 15.0
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var tapAction: ((_ animatedTextField: UIAnimatedTextField) -> Void)?
    private var isShownInfo: Bool = false
    
    private var state: AnimatedTextFieldState {
        var state: AnimatedTextFieldState = .placeholder
        
        if textField.text?.characters.count ?? 0 > 0 || textField.isFirstResponder {
            state = .text
        }
        
        return state
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    private func initialization() {
        textField = EditableTextField()
        textField.delegate = self
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        textField.getType = { [weak self] in
            return self?.type
        }
        addSubview(textField)
        
        placeholderLabel = UILabel()
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.textColor = placeholderBottomColor
        placeholderLabel.textAlignment = .center
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.minimumScaleFactor = 0.5
        addSubview(placeholderLabel)
        
        lineView = UIView()
        lineView.backgroundColor = placeholderLabel.textColor
        addSubview(lineView)
        
        disclosureIndicatorImageView = UIImageView()
        disclosureIndicatorImageView.image = UIImage(named: "disclosureIndicator")
        disclosureIndicatorImageView.contentMode = .center
        disclosureIndicatorImageView.isHidden = true
        addSubview(disclosureIndicatorImageView)
        
        layoutSubviews()
    }
    
    // MARK: - Layout
    
    private func textFieldFrame() -> CGRect {
        var size = bounds.size
        var origin = bounds.origin
        
        size.height = 2/3 * size.height
        origin.y = 1/3 * bounds.size.height
        
        if isDisclosureIndicatorVisible {
            origin.x += CGFloat(UIAnimatedTextField.disclosureIndicatorWidth)
            size.width -= CGFloat(UIAnimatedTextField.disclosureIndicatorWidth) * 2
        }
        
        let textFieldBounds = CGRect(origin: origin, size: size)
        return textFieldBounds
    }
    
    private func placeholderLabelFrame(state: AnimatedTextFieldState) -> CGRect {
        if state == .placeholder {
            return textFieldFrame()
        } else {
            var size = bounds.size
            size.height = 1/3 * size.height
            
            let placeholderLabelBounds = CGRect(origin: bounds.origin, size: size)
            return placeholderLabelBounds
        }
    }
    
    private func disclosureIndicatorFrame() -> CGRect {
        let fieldFrame = textFieldFrame()
        let frame = CGRect(x: bounds.width - CGFloat(UIAnimatedTextField.disclosureIndicatorWidth),
                           y: fieldFrame.origin.y,
                           width: CGFloat(UIAnimatedTextField.disclosureIndicatorWidth),
                           height: fieldFrame.height)
        return frame
    }
    
    private func placeholderLabelTransform(state: AnimatedTextFieldState) -> CGAffineTransform {
        if state == .placeholder {
            return CGAffineTransform.identity
        } else {
            return CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = textFieldFrame()
        
        if isDisclosureIndicatorVisible {
            disclosureIndicatorImageView.frame = disclosureIndicatorFrame()
        }
        
        setState(toState: state, duration: 0)
        
        lineView.frame = CGRect(x: 0,
                                y: bounds.height - UIView.onePixelInPoints * 2,
                                width: bounds.width,
                                height: UIView.onePixelInPoints)
    }
    
    // MARK: - Animation
    
    func setState(toState state: AnimatedTextFieldState, duration: TimeInterval) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .beginFromCurrentState,
            animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.placeholderLabel.frame = strongSelf.placeholderLabelFrame(state: state)
                strongSelf.placeholderLabel.transform = strongSelf.placeholderLabelTransform(state: state)
                switch state {
                case .placeholder:
                    strongSelf.placeholderLabel.textColor = strongSelf.placeholderBottomColor
                case .text:
                    strongSelf.placeholderLabel.textColor = strongSelf.placeholderTopColor
                }
            },
            completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        delegate?.animatedTextFieldWillReactForTap?()
        tapAction?(self)
    }
    
    func validateText() -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        switch type {
        case .url:
            return text.isValidEmail
        default:
            break
        }
        
        return true
    }
    
    func showInfo(infoText: String) {
        guard !isShownInfo else {
            return
        }
        
        isShownInfo = true
        
        let currentPlaceholder = placeholder
        
        UIView.transition(with: placeholderLabel,
                          duration: 0.5,
                          options: .transitionFlipFromTop,
                          animations: { [weak self] in
                            self?.placeholder = infoText
            }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            guard let placeholderLabel = self?.placeholderLabel else {
                return
            }
            
            UIView.transition(with: placeholderLabel,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self?.placeholder = currentPlaceholder
            }, completion: { [weak self] flag in
                self?.isShownInfo = false
            })
        }
    }
    
    // MARK: - Private
    
    private func getDateInputView() -> UIDatePicker {
        let currentDate = Date()
        
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        datePicker.setDate(currentDate, animated: true)
        datePicker.maximumDate = currentDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }
    
    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedDate = datePicker.date
        text = TIDateFormatter.longDate(from: datePicker.date)
    }
    
    private func getDateInputAccessoryView() -> UIView {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        toolbar.autoresizingMask = [.flexibleWidth]
        toolbar.barTintColor = UIColor.white
        
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "Done",
                                       style: .done,
                                       target: self,
                                       action: #selector(datePickerDoneAction))
        let attributes = [
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        doneItem.setTitleTextAttributes(attributes, for: .normal)
        
        toolbar.items = [spacerItem, doneItem]
        
        return toolbar
    }
    
    @objc private func datePickerDoneAction() {
        textField.resignFirstResponder()
    }
    
    @objc private func textFieldValueDidChange() {
        delegate?.animatedTextFieldValueDidChange?(self)
    }
    
}

extension UIAnimatedTextField: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var result = true
        
        if let delegateResult = delegate?.animatedTextFieldShouldBeginEditing?(self) {
            result = delegateResult
        }
        
        return result
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.characters.count ?? 0 == 0 {
            setState(toState: .text, duration: UIAnimatedTextField.animationDuration)
        }
        
        if case .date = type {
            if let datePicker = textField.inputView as? UIDatePicker {
                textField.text = TIDateFormatter.longDate(from: datePicker.date)
            }
        }
        
        delegate?.animatedTextFieldDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var result = true
        
        if let delegateResult = delegate?.animatedTextFieldShouldEndEditing?(self) {
            result = delegateResult
        }
        
        return result
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count ?? 0 == 0 {
            setState(toState: .placeholder, duration: UIAnimatedTextField.animationDuration)
        }
        
        delegate?.animatedTextFieldDidEndEditing?(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var result = true
        
        if let delegateResult = delegate?.animatedTextField?(self, shouldChangeCharactersInRange: range,
                                                             replacementString: string) {
            result = delegateResult
        }
        
        if string == " " {
            if textField.text?.characters.count ?? 0 == 0 {
                result = false
            }
            
            switch type {
            case .password, .url:
                result = false
            default:
                break
            }
        }
        
        return result
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        var result = true
        
        if let delegateResult = delegate?.animatedTextFieldShouldClear?(self) {
            result = delegateResult
        }
        
        return result
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var result = true
        
        if let delegateResult = delegate?.animatedTextFieldShouldReturn?(self) {
            result = delegateResult
        }
        
        return result
    }
    
}
