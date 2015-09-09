//
//  SettingController.swift
//  Install
//
//  Created by Nguyen Bui on 1/3/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit
import CoreData

class SettingController: TextFieldScrollingController {
    let appSettingService = AppSettingService()
    let userService = UserService()

    
    @IBOutlet var scvMain: UIScrollView!
    @IBOutlet var txtWebServiceURL: UITextField!
    @IBOutlet var segMapProvider: UISegmentedControl!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var swShowPassword: UISwitch!
    
//    @IBAction func btnSave_Click(sender: AnyObject) {
//        self.saveSettings()
//    }
    @IBAction func btnSave_Click(sender: AnyObject) {
        self.saveSettings()
    }
    
    
    @IBAction func btnCancel_Click(sender: AnyObject) {
        self.showDashBoard()
    }
//    @IBAction func btnCancel_Click(sender: AnyObject) {
//        self.showDashBoard()
//    }
    
    @IBAction func btnSignOut_Click(sender: AnyObject) {
        appSettingService.setUserName("")
        appSettingService.setPassword("")
        
        global.user = User()
        
        //add login scene to root view, then go to Login View
        let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! ViewController
        self.navigationController?.viewControllers.insert(login, atIndex: 0)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func swShowPassword_ValueChanged(sender: AnyObject) {
        txtPassword.secureTextEntry = !swShowPassword.on
    }
    
    private func loadSettings() {
        txtWebServiceURL.text = appSettingService.getWebServiceURL()
        
        if appSettingService.getMapURL() == Settings.MAP_OPENLAYERS_URL.rawValue {
            segMapProvider.selectedSegmentIndex = 0
        } else {
            segMapProvider.selectedSegmentIndex = 1
        }
        
        txtUserName.text = appSettingService.getUserName()
        txtPassword.text = appSettingService.getPassword()
        
//        if appSettingService.getDeviceMode() == Settings.SINGLE_DEVICE_MODE.rawValue {
//            segDeviceMode.selectedSegmentIndex = 0
//        } else {
//            segDeviceMode.selectedSegmentIndex = 1
//        }
    }
    
    private func saveSettings() {
        
        let serviceURL = txtWebServiceURL.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let mapProvider = segMapProvider.selectedSegmentIndex == 0 ? Settings.MAP_OPENLAYERS_URL.rawValue : Settings.MAP_GOOGLE_URL.rawValue
        let userName = txtUserName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let password = txtPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        let deviceMode = segDeviceMode.selectedSegmentIndex == 0 ? Settings.SINGLE_DEVICE_MODE.rawValue : Settings.MULTIPLE_DEVICE_MODE.rawValue
        
        //show loading dialog
        self.view.makeToastActivityWithMessage(message: "Waiting...")

        //check valid service api url
        Alamofire.manager.request(.GET, serviceURL)
            .response {(request, response, data, error) in
               
                if error == nil {
                    //re-login
                    global.baseURL = serviceURL
                    self.userService.login(userName: userName, password:password){ user in
                        //hide loading dialog
                        self.view.hideToastActivity()
                        if user != nil {
                            //set global variable
                            global.user = User()
                            global.user.updateInfo(user!)
                            
                            self.appSettingService.setWebServiceURL(serviceURL)
                            self.appSettingService.setMapURL(mapProvider)
                            self.appSettingService.setUserName(userName)
                            self.appSettingService.setPassword(password)
//                            self.appSettingService.setDeviceMode(deviceMode)
                            
                            self.view.makeToast(message: "Settings have been saved!")
                        } else {
                            self.view.makeToast(message: "This account is invalid for  the new Web Service URL. Please change username and password.")
                        }
                    }
                    
                } else {
                    //hide loading dialog
                    self.view.hideToastActivity()
                    
                    self.view.makeToast(message: "Invalid WebService URL. Please enter again!")
                    self.txtWebServiceURL.becomeFirstResponder()
                }
            }
    }
    
    func showDashBoard() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showDashBoard")

        //set ScrollView border
        scvMain.layer.cornerRadius = 5.0
        scvMain.layer.masksToBounds = true
        scvMain.layer.borderColor = UIColor.darkGrayColor().CGColor
        scvMain.layer.borderWidth = 1.0
        scvMain.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1)
        
        //load data
//        self.loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
