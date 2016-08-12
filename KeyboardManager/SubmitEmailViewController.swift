//
//  SubmitEmailViewController.swift
//  KeyboardManager
//
//  Created by Justine Kay on 8/10/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

struct DeviceManager {
    static let deviceHeight = UIWindow(frame: UIScreen.mainScreen().bounds).bounds.height
    
    static var isIPhone4: Bool { return deviceHeight <= 480 }
    static var isIPhone5: Bool { return (deviceHeight > 480) && (deviceHeight <= 568) }
    static var isIPhone6: Bool { return deviceHeight > 568 }
    
}

class SubmitEmailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var emailAddressTextFieldTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private let kImageViewHeightConstraint_iPhone4: CGFloat = 0
    private let kImageViewHeightConstraint_iPhone5: CGFloat  = 140
    private let kEmailAddressTextFieldTopConstraint_iPhone5: CGFloat  = 25
    private let kOriginalNextButtonBottomConstraint: CGFloat  = 0
    private let kOriginalImageViewHeightConstraint: CGFloat  = 190
    private let kOriginalEmailAddressTextFieldTopConstraint: CGFloat  = 53
    private let kTransformScale: CGFloat = 1.1
    private let kOriginalScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpKeyboard()
        setUpKeyboardNotifications()
        setUpTapGestureRecognizer()
    }
    
    // MARK: - UITapGestureRecognizer
    
    private func setUpTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SubmitEmailViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        emailAddressTextField.resignFirstResponder()
    }
    
    // MARK: - UITextField / Keyboard
    
    private func setUpKeyboard() {
        emailAddressTextField.canBecomeFirstResponder()
        emailAddressTextField.keyboardType = .Twitter
    }
    
    private func setUpKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_: )), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_: )), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardFrame: NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        animateKeyboardWillShow(keyboardRect.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateKeyboardWillHide()
    }
    
    // MARK: - Animations
    
    private func animateKeyboardWillShow(height: CGFloat) {
        UIView.animateWithDuration(2.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.nextButtonBottomConstraint.constant = height
            
            if DeviceManager.isIPhone4 {
                self.imageViewHeightConstraint.constant = self.kImageViewHeightConstraint_iPhone4
            } else if DeviceManager.isIPhone5 {
                self.imageViewHeightConstraint.constant = self.kImageViewHeightConstraint_iPhone5
                self.emailAddressTextFieldTopConstraint.constant = self.kEmailAddressTextFieldTopConstraint_iPhone5
            }
        }) { _ in
            self.pulseAnimation()
        }
    }
    
    private func animateKeyboardWillHide() {
        UIView.animateWithDuration(2.0, delay: 0, options: .CurveEaseInOut, animations: {
            self.nextButtonBottomConstraint.constant = self.kOriginalNextButtonBottomConstraint
            self.imageViewHeightConstraint.constant = self.kOriginalImageViewHeightConstraint
            self.emailAddressTextFieldTopConstraint.constant = self.kOriginalEmailAddressTextFieldTopConstraint
        }) { _ in
            self.pulseAnimation()
        }
    }
    
    private func pulseAnimation() {
        UIView.animateWithDuration(
            0.25,
            animations: {
                self.imageView.transform = CGAffineTransformMakeScale(self.kTransformScale, self.kTransformScale)
                self.nextbutton.transform = CGAffineTransformMakeScale(self.kTransformScale, self.kTransformScale)
                self.emailAddressTextField.transform = CGAffineTransformMakeScale(self.kTransformScale, self.kTransformScale)
        }) { _ in
            UIView.animateWithDuration(
                0.25,
                animations: {
                    self.imageView.transform = CGAffineTransformMakeScale(self.kOriginalScale, self.kOriginalScale)
                    self.nextbutton.transform = CGAffineTransformMakeScale(self.kOriginalScale, self.kOriginalScale)
                    self.emailAddressTextField.transform = CGAffineTransformMakeScale(self.kOriginalScale, self.kOriginalScale)
                }, completion: nil
            )
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        //Present next view controller
    }
    
}

