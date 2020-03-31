//
//  TypingControl.swift
//  SpeedMathMobile
//
//  Created by Munir Wanis on 2020-03-31.
//  Copyright © 2020 Munir Wanis. All rights reserved.
//

import UIKit
import SwiftUI

extension Notification.Name {
    static let enterNumber = Notification.Name("enterNumber")
    static let removeNumber = Notification.Name("removeNumber")
    static let submitAnswer = Notification.Name("submitAnswer")
}

// View of type UIControl so we can trigger the keyboard
class TypingControl: UIControl, UIKeyInput {
    // UILabel is the equivalent to Text from SwiftUI
    let label = UILabel()
    
    // UIToolbar will be the tool to show a Submit button to the Keyboard
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: frame.width, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        
        let submit = UIBarButtonItem(title: "Submit",
                                     style: .done,
                                     target: self,
                                     action: #selector(submitAction))
        
        toolbar.setItems([spacer, submit], animated: false)
        return toolbar
    }()
    
    private var currentText = ""
    
    // We always want a .numberPad Keyboard
    var keyboardType: UIKeyboardType = .numberPad
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    // It's the accessory that will show in the top of the keyboard, in this case the toolbar
    override var inputAccessoryView: UIView? {
        get {
            toolbar
        }
    }
    
    func insertText(_ text: String) {
        // If the text is a number, we trigger the enterNumber notification
        // If the user is using a Keyboard, he can trigger the enter button which is \n character
        if let number = Int(text) {
            currentText = text
            NotificationCenter.default.post(name: .enterNumber, object: number)
        } else if text == "\n" {
            NotificationCenter.default.post(name: .submitAnswer, object: nil)
        }
    }
    
    // Funcion to delete the number, it triggers the remove number notification
    func deleteBackward() {
        NotificationCenter.default.post(name: .removeNumber, object: nil)
    }
    
    var hasText: Bool {
        currentText.isEmpty == false
    }
    
    // Since we can't trigger the Enter button in the .numberPad keyboard,
    // we create a submitAction function so we can trigger it manually
    @objc private func submitAction() {
        NotificationCenter.default.post(name: .submitAnswer, object: nil)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        // Setup constraints to the UILabel insite de UIControl view
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        // This could be better... Should find a solution to setup
        // the font and textColor through the SwiftUI API
        label.font = label.font.withSize(24)
        label.textColor = .white
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Bridge between SwiftUI and UIKit, transforming the UIKit view into a
// usable SwiftUI view, we must implement those two methods
struct TypingView: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> TypingControl {
        TypingControl()
    }
    
    func updateUIView(_ uiView: TypingControl, context: Context) {
        // Updates the UILabel text
        uiView.label.text = text
        
        // That triggers the Keyboard to open
        uiView.becomeFirstResponder()
    }
}
