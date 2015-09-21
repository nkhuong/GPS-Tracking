//
//  ViewController.swift
//  GPS Tracking
//
//  Created by Khuong Phan Nhat on 9/8/15.
//  Copyright (c) 2015 Skypatrol. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

<<<<<<< HEAD
    var userService: UserService = UserService()
    var installService: InstallationRequestService = InstallationRequestService()
    var savedDeviceService: SavedDeviceService = SavedDeviceService()
    var settingService: AppSettingService = AppSettingService()
    
//    var serial: String = ""
    
    
    @IBOutlet weak var txtUserName: UITextField!
=======
    
    @IBOutlet weak var txtUseName: UITextField!
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func Login(sender: AnyObject) {
        
<<<<<<< HEAD
        //check internet connection
        if !Reachability.isConnectedToNetwork() {
            self.view.makeToast(message: NoInterNetConnection)
            return
        }
        
        //check username & password from service api
        let userName = txtUserName.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let password = txtPassword.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (countElements(userName) > 0 && countElements(password) > 0) {
            //show loading dialog
            self.view.makeToastActivityWithMessage(message: "Loading...")
            
            self.userService.login(userName: userName, password:password){ user in
                //hide loading dialog
                self.view.hideToastActivity()
                if user != nil {
                    //set global variable
                    global.user.updateInfo(user!)
                    //save login data to settings
                    self.settingService.setUserName(userName)
                    self.settingService.setPassword(password)
                    
                    let dashBoard = self.storyboard?.instantiateViewControllerWithIdentifier("DashBoard") as DashBoardController
                    self.navigationController?.pushViewController(dashBoard, animated: true)
                } else {
                    self.view.makeToast(message: self.userService.errorMessage)
                }
            }
            
        }
        else {
            self.view.makeToast(message: "Please enter username and password!")
        }
        
=======
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
    }
    
    @IBAction func Registration(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
<<<<<<< HEAD

        //set background image
//        let navBackgroundImage:UIImage! = UIImage(named: "top_bar_bg")
//        self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage, forBarMetrics: .Default)

        
        //hide nav bar
//        self.navigationController?.navigationBar.hidden = true
        
        
        //set Service URL
        global.baseURL = settingService.getWebServiceURL()

        txtUserName.text = "kphan"
=======
        
        txtUseName.text = "kphan"
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
        txtPassword.text = "kphan123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

