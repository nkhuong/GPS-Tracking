//
//  TextFieldScrollingController.swift
//  Install
//
//  Created by Tran Thanh Dan on 3/2/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class TextFieldScrollingController : UIViewController {
    
    var _scrollView: UIScrollView!
    var _activeTextField: UITextField? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        //center.addObserver(self, selector: "keyboardOnScreen:", name: UIKeyboardDidShowNotification, object: nil)
        //center.addObserver(self, selector: "keyboardOffScreen:", name: UIKeyboardDidHideNotification, object: nil)
        
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.findScrollView(self.view)
        self.addTargetForTextField(self.view)
        
    }
    
    private func findScrollView (view: AnyObject) {
        if (view.isKindOfClass(UIScrollView)) {
            self._scrollView = view as! UIScrollView
        } else if view.isKindOfClass(UIView) {
            for subview in view.subviews {
                self.findScrollView(subview)
            }
        }
    }
    
    private func addTargetForTextField(view: AnyObject) {
        if (view.isKindOfClass(UITextField)) {
            var textField = view as! UITextField
            textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
            
            textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)

        } else if view.isKindOfClass(UIView) || view.isKindOfClass(UIScrollView) {
            for subview in view.subviews {
                self.addTargetForTextField(subview)
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if _activeTextField != nil  {
            let info: NSDictionary  = notification.userInfo!
            let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size
            let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
            _scrollView.contentInset = contentInsets
            _scrollView.scrollIndicatorInsets = contentInsets
            //you may not need to scroll, see if the active field is already visible
            if keyboardFrame.origin.y < _activeTextField!.frame.origin.y {
                let scrollPoint:CGPoint = CGPointMake(0.0, _activeTextField!.frame.origin.y - kbSize!.height)
                _scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
    }
    /*
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        //you may not need to scroll, see if the active field is already visible
        //if (!CGRectContainsPoint(aRect, activeTextField!.frame.origin) ) {
        if keyboardFrame.origin.y < _activeTextField!.frame.origin.y {
            let scrollPoint:CGPoint = CGPointMake(0.0, _activeTextField!.frame.origin.y - kbSize!.height)
            _scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardOffScreen(notification: NSNotification){
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        _scrollView.contentInset = contentInsets
        _scrollView.scrollIndicatorInsets = contentInsets
    }
    */
    func textFieldDidReturn(textField: UITextField!)
    {
        textField.resignFirstResponder()
        _activeTextField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        _activeTextField = textField
    }
}
