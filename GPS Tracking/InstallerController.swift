//
//  InstallerController.swift
//  Install
//
//  Created by Nguyen Bui on 1/3/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class InstallerController: TextFieldScrollingController {
    var isUpdated = false
    let userService: UserService = UserService()
    
//    @IBOutlet var scvMain: UIScrollView!
    @IBOutlet var scvMain: UIScrollView!
//    @IBOutlet var mainView: UIView!
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblConfirm: UILabel!
    @IBOutlet var txtConfirm: UITextField!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var txtEmail: UITextField!
    
//    @IBOutlet var lblUserName: UILabel!
//    @IBOutlet var txtUserName: UITextField!
//    @IBOutlet var lblPassword: UILabel!
//    @IBOutlet var txtPassword: UITextField!
//    @IBOutlet var lblConfirm: UILabel!
//    @IBOutlet var txtConfirm: UITextField!
//    @IBOutlet var lblEmail: UILabel!
//    @IBOutlet var txtEmail: UITextField!
//    @IBOutlet var txtFirstName: UITextField!
//    @IBOutlet var txtLastName: UITextField!
//    @IBOutlet var txtAddress: UITextField!
//    @IBOutlet var txtCity: UITextField!
//    @IBOutlet var txtState: UITextField!
//    @IBOutlet var txtZip: UITextField!
//    @IBOutlet var txtPhone: UITextField!
  
    
    
    @IBAction func btnSave_Click(sender: AnyObject) {
        //check internet connection
        if !Reachability.isConnectedToNetwork() {
            self.view.makeToast(message: NoInterNetConnection)
            return
        }
        
        var userName = ""
        var password = ""
        if self.isUpdated == false {
            
            userName = txtUserName.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            password = txtPassword.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            var confirm = txtConfirm.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if countElements(userName) == 0 {
                self.view.makeToast(message: "Please enter your username!")
                self.txtUserName.becomeFirstResponder()
                return
            }
            
            if countElements(password) == 0 {
                self.view.makeToast(message: "Please enter your password!")
                self.txtPassword.becomeFirstResponder()
                return
            }
            
            if password != confirm {
                self.view.makeToast(message: "Confirm password doesn't match with password!")
                self.txtConfirm.becomeFirstResponder()
                return
            }
        }
        
//        var firstName = txtFirstName.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var lastName = txtLastName.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var address = txtAddress.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var city = txtCity.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var state = txtState.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var zip = txtZip.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        var phone = txtPhone.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var email = txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if countElements(email) == 0 {
            self.view.makeToast(message: "Please enter your email!")
            self.txtEmail.becomeFirstResponder()
            return
        }
        
        if !email.isEmail() {
            self.view.makeToast(message: "Your email is invalid!")
            self.txtEmail.becomeFirstResponder()
            return
        }
        
//        if countElements(phone) == 0 {
//            self.view.makeToast(message: "Please enter your phone!")
//            self.txtPhone.becomeFirstResponder()
//            return
//        }
        
        //show loading dialog
        self.view.makeToastActivityWithMessage(message: "Loading...")
        
        var userData = User()
        if self.isUpdated == false {
            userData.userName = userName
            userData.password = password
        }
        else {
            userData.loginToken = global.user.loginToken
        }
//        userData.firstName = firstName
//        userData.lastName = lastName
//        userData.address = address
//        userData.city = city
//        userData.state = state
//        userData.zip = zip
//        userData.phone = phone
//        userData.email = email
        
        if self.isUpdated == false { //create user
            self.userService.createUser(userData) { user in
                //hide loading dialog
                self.view.hideToastActivity()
                if user != nil {
                    
                    //keep loginToken
                    user!.loginToken =  global.user.loginToken
                    //set global variable
                    global.user.updateInfo(user!)
                    
                    //show dialog and redirect to login view
                    let alert = UIAlertController(title: "Info", message: "An email was sent to " + global.user.email + ", go to your email and verify account", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                        //back to login view
                        self.backAction()
                    }))
     
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.view.makeToast(message: self.userService.errorMessage)
                }
            }
        } else { //update user
            self.userService.updateUserInfo(userData) { success in
                //hide loading dialog
                self.view.hideToastActivity()
                if success {
                    //show success message and redirect to login view
                    self.view.makeToast(message: "Installer profile is updated!")
                    self.backAction()
                } else {
                    self.view.makeToast(message: self.userService.errorMessage)
                }
            }
        }
    }
    func backAction() {
        //back to Login, hide nav bar
        if !self.isUpdated {
            self.navigationController?.navigationBar.hidden = true
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isUpdated {
            //remove Constraints
//            lblUserName.removeConstraints(lblUserName.constraints())
//            txtUserName.removeConstraints(txtUserName.constraints())
//            lblPassword.removeConstraints(lblPassword.constraints())
//            txtPassword.removeConstraints(txtPassword.constraints())
//            lblConfirm.removeConstraints(lblConfirm.constraints())
//            txtConfirm.removeConstraints(txtConfirm.constraints())
            //remove contraints from mainView to child views: Margin, Alignment, ...
//            for constraint in mainView.constraints() {
//                var item: AnyObject! = constraint.firstItem
//                if item is UILabel {
////                    if item === lblUserName || item === lblPassword || item === lblConfirm {
////                        mainView.removeConstraint(constraint as NSLayoutConstraint)
////                    }
//                } else if item is UITextField {
//                    if item === txtUserName || item === txtPassword || item === txtConfirm {
//                        mainView.removeConstraint(constraint as NSLayoutConstraint)
//                    }
//                }
//            }
            
            //hide Views
//            lblUserName.hidden = true
//            txtUserName.hidden = true
//            lblPassword.hidden = true
//            txtPassword.hidden = true
//            lblConfirm.hidden = true
//            txtConfirm.hidden = true

            //add constraint to Email Label
//            let topConstraint = NSLayoutConstraint(item: lblEmail, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 15)
//            mainView.addConstraint(topConstraint)
//            mainView.frame.size.height = 558
            
            //show loading dialog
            self.view.makeToastActivityWithMessage(message: "Loading...")
        
            self.userService.getUserInfo(global.user.loginToken) { user in
                //hide loading dialog
                self.view.hideToastActivity()
                if user != nil {
//                    self.txtFirstName.text = user!.firstName
//                    self.txtLastName.text = user!.lastName
//                    self.txtAddress.text = user!.address
//                    self.txtCity.text = user!.city
//                    self.txtState.text = user!.state
//                    self.txtZip.text = user!.zip
//                    self.txtPhone.text = user!.phone
//                    self.txtEmail.text = user!.email
                } else {
                    self.view.makeToast(message: self.userService.errorMessage)
                }
            }
        }
        
        //set navigation bar
//        self.navigationController?.navigationBar.hidden = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        
        //set ScrollView border
//        scvMain.layer.cornerRadius = 5.0
//        scvMain.layer.masksToBounds = true
//        scvMain.layer.borderColor = UIColor.darkGrayColor().CGColor
//        scvMain.layer.borderWidth = 1.0
//        scvMain.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
