//
//  TestDeviceCommandController.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/3/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class TestDeviceCommandController: UIViewController {
    
    let appSettingService = AppSettingService()
    let deviceService = DeviceService()
    
    @IBOutlet var lblDeviceSerial: UILabel!
    @IBOutlet var btnShowHideCommands: UIButton!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var lblLocationInfo: UILabel!
    @IBOutlet var vwButtonGroup: UIView!
    @IBOutlet var btnLocate: UIButton!
    @IBOutlet var btnEnableStarter: UIButton!
    @IBOutlet var btnDisableStarter: UIButton!
    @IBOutlet var btnReminderOn: UIButton!
    @IBOutlet var btnReminderOff: UIButton!
    
    var transactionId:Int = 0
    var forceStopSending = true
    var isShowCommand = true
   
    @IBAction func btnShowHideCommands_Click(sender: AnyObject) {
        isShowCommand = !isShowCommand
        self.showCommands(isShowCommand)
//        if isShowCommand {
//            isShowCommand = false
//            btnShowHideCommands.setTitle("Show Commands", forState: .Normal)
//            self.setHeight(vwButtonGroup, 0)
//        }
//        else {
//            isShowCommand = true
//            btnShowHideCommands.setTitle("Hide Commands", forState: .Normal)
//            self.setHeight(vwButtonGroup, 100)
//        }
    }
    //show or hide of View by height (0 or 100)
    func setHeight(sender: UIView, _ height: Float)  {
        for constraint in sender.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                let heightCons = constraint as NSLayoutConstraint
                heightCons.constant = CGFloat(height)
                break
            }
        }
    }
    //show or hide Button bar
    func showCommands(isShow: Bool) {
        if isShow {
            btnShowHideCommands.setTitle("Hide Commands", forState: .Normal)
            self.setHeight(vwButtonGroup, 100)
            
        } else {
            btnShowHideCommands.setTitle("Show Commands", forState: .Normal)
            self.setHeight(vwButtonGroup, 0)
        }
        
        self.btnLocate.hidden = !isShow
        self.btnEnableStarter.hidden = !isShow
        self.btnDisableStarter.hidden = !isShow
        self.btnReminderOn.hidden = !isShow
        self.btnReminderOff.hidden = !isShow
    }
    
    @IBAction func btnLocate_Click(sender: AnyObject) {
        self.invokeSendCommand(Commands.LOCATE)
    }
    
    @IBAction func btnEnableStarter_Click(sender: AnyObject) {
        self.invokeSendCommand(Commands.ENABLE_STARTER)
    }
    @IBAction func btnDisableStarter_Click(sender: AnyObject) {
        self.invokeSendCommand(Commands.DISABLE_STARTER)
    }
    @IBAction func btnReminderOn_Click(sender: AnyObject) {
        self.invokeSendCommand(Commands.ENABLE_LATE_PAYMENT)
    }
    @IBAction func btnReminderOff_Click(sender: AnyObject) {
        self.invokeSendCommand(Commands.DISABLE_LATE_PAYMENT)
    }
    @IBAction func btnContinue_Click(sender: AnyObject) {
        self.showCompleteInstallation()
    }
    
    func invokeSendCommand(command: Commands) {
        self.forceStopSending = false
        self.transactionId = 0
        self.setHeight(lblLocationInfo, 0)
        
        //show loading dialog
        self.view.makeToastActivityWithMessage(message: "Loading...")
        
        self.deviceService.sendRequest(loginToken: global.user.loginToken, authToken: global.installationInfo.authToken, serial: global.installationInfo.serialNumber, commandType: command) { result in
            
            self.transactionId = result
            if (self.transactionId <= 0) { // cannot create command transaction
                //hide loading dialog
                self.view.hideToastActivity()
                
                //update command messages
                var (failed, passed) = global.commandResults[command.rawValue]!
                global.commandResults[command.rawValue] = (++failed, passed)
                
                self.view.makeToast(message: "Can not send command!")
                
                //update sending status
                self.forceStopSending = true
                
            } else if (self.transactionId > 0) {
                self.checkStatus(loginToken: global.user.loginToken, authToken: global.installationInfo.authToken, serial: global.installationInfo.serialNumber, commandType: command)
            }
        }
    }
    func checkStatus(loginToken loginToken: String, authToken: String, serial: String, commandType: Commands) {
//         self.deviceService.sendRequest(loginToken: loginToken, authToken: authToken, serial: serial, commandType: commandType) {result in
        
//            self.transactionId = result
            if (!self.forceStopSending) {
//                if (self.transactionId == -1) { // cannot create command transaction
//                    //hide loading dialog
//                    self.view.hideToastActivity()
//                    
//                    //update command messages
//                    var (failed, passed) = global.commandResults[commandType.rawValue]!
//                    global.commandResults[commandType.rawValue] = (++failed, passed)
//                    
//                    self.view.makeToast(message: "Can not send command!")
//                    
//                    //update sending status
//                    self.forceStopSending = true
//                    
//                } else if (self.transactionId > 0) {
                    //sleep in 10 seconds
                    sleep(10)
                    
                    self.deviceService.checkCommandStatus(authToken: authToken, transactionId: self.transactionId) { commandStatusResult in
                        if commandStatusResult == nil {
                            if self.deviceService.errorMessage == "In Progress" {
                                //resend send command
                                self.checkStatus(loginToken: loginToken, authToken: authToken, serial: serial, commandType: commandType)
                            } else {
                                //hide loading dialog
                                self.view.hideToastActivity()
                                
                                //update command messages
                                var (failed, passed) = global.commandResults[commandType.rawValue]!
                                global.commandResults[commandType.rawValue] = (++failed, passed)
                                
                                self.view.makeToast(message: self.deviceService.errorMessage)
                                
                                //update sending status
                                self.forceStopSending = true
                            }
                        } else {
                            //hide loading dialog
                            self.view.hideToastActivity()
                            
                            //update command messages
                            var (failed, passed) = global.commandResults[commandType.rawValue]!
                            global.commandResults[commandType.rawValue] = (failed, ++passed)
                                                      
                            if commandType == Commands.LOCATE {
                                //invoke javascript function
                                self.webView.stringByEvaluatingJavaScriptFromString("moveMarker(\(commandStatusResult!.latitude), \(commandStatusResult!.longitude));")

                                self.lblLocationInfo.text = commandStatusResult!.location
                                self.setHeight(self.lblLocationInfo, 42)
                                // hide command buttons
                                self.isShowCommand = false
                                self.showCommands(self.isShowCommand)
//                                self.setHeight(self.vwButtonGroup, 0)
//                                self.btnShowHideCommands.setTitle("Show Commands", forState: .Normal)
                                // show successful message
                                self.view.makeToast(message: "Locate successfully at " + commandStatusResult!.location)
                            } else {
                                self.view.makeToast(message: CommandNames[commandType.rawValue] + " run successully!")
                            }
                            
                            //update sending status
                            self.forceStopSending = true
                        }
                    }
//                }
            } //end force stop sending
            else {
                //hide loading dialog
                self.view.hideToastActivity()
            }
//        }
    }
    
    func showInstallDevice() {
        if (self.confirmMoving()) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func showCompleteInstallation() {
        if (self.confirmMoving()) {
            //check enable late payment
            let (failed, passed) = global.commandResults[Commands.ENABLE_LATE_PAYMENT.rawValue]!
            global.installationInfo.starterInterruptInstalled = (passed > 0 || failed > 0)
            global.installationInfo.location = lblLocationInfo.text!
            
            let completeInstallation = self.storyboard?.instantiateViewControllerWithIdentifier("CompleteInstallation") as! CompleteInstallationController
            self.navigationController?.pushViewController(completeInstallation, animated: true)
        }
    }
    
    func confirmMoving() -> Bool {
        var canMove = true
        if (!self.forceStopSending) {
            let confirmationDialog = UIAlertController(title: "Confirm!", message: "Are you sure you want to cancel 'Sending Command'?", preferredStyle: UIAlertControllerStyle.Alert)
            confirmationDialog.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: {
                (alert: UIAlertAction) -> Void in
                canMove = false
            }))
            confirmationDialog.addAction(UIAlertAction(title: "YES", style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                canMove = true
                self.forceStopSending = true
                sleep(2)
            }))
            self.presentViewController(confirmationDialog, animated: true, completion: nil)
        }
        return canMove
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Back & Next buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showInstallDevice")
        
        let rightItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "next_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showCompleteInstallation")
        
        self.navigationItem.rightBarButtonItem = rightItem
        //hide label location  info
        self.setHeight(lblLocationInfo, 0)
        
        //show device serial
        self.lblDeviceSerial.text = "Device: " + global.installationInfo.serialNumber

        //Load default map
        let defaultMap = appSettingService.getMapURL()
        let path:String! = NSBundle.mainBundle().pathForResource(defaultMap, ofType: "html", inDirectory: "localHTML")
        let url:NSURL! = NSURL(fileURLWithPath: path)
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
        //init command Results
        global.commandResults = [0:(0,0), 1:(0,0), 2:(0,0), 3:(0,0), 4:(0,0)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
