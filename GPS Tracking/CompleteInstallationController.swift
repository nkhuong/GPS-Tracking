//
//  CompleteInstallationController.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/4/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit
import QuartzCore

class CompleteInstallationController: TextFieldScrollingController {

    let savedDeviceService = SavedDeviceService()
    let installrequestService = InstallationRequestService()
    
    @IBOutlet var scvMain: UIScrollView!
    
    @IBOutlet var lblAccountName: UILabel!
    @IBOutlet var lblInstaller: UILabel!
    @IBOutlet var lblSerialNumber: UILabel!
    @IBOutlet var lblStockNumber: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var lblVin: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblVehicleYear: UILabel!
    @IBOutlet var lblModel: UILabel!
    @IBOutlet var lblColor: UILabel!
    @IBOutlet var lblLicensePlate: UILabel!
    @IBOutlet var lblMarketPrice: UILabel!
    @IBOutlet var lblLocateMessages: UILabel!
    @IBOutlet var lblReminderOnMessages: UILabel!
    @IBOutlet var lblReminderOffMessages: UILabel!
    @IBOutlet var lblStarterEnableMessages: UILabel!
    @IBOutlet var lblStarterDisableMessages: UILabel!
    @IBOutlet var txtComment: UITextField!
    @IBAction func btnComplete_Click(sender: AnyObject) {
        
        let comment = txtComment.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if countElements(comment) > 10 {
            self.view.makeToast(message: "Comment is too long!")
            self.txtComment.becomeFirstResponder()
            return
        }
        
        global.installationInfo.comment = comment
        
        //check internet connection
        if !Reachability.isConnectedToNetwork() {
            let offlineConfirmation = UIAlertController(title: "Error!", message: "Your connection has problem! Do you want to save your installation information?", preferredStyle: UIAlertControllerStyle.Alert)
            offlineConfirmation.addAction(UIAlertAction(title: "CANCEL", style: .Cancel, handler: nil))
            offlineConfirmation.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                self.saveDeviceIntoDB()
            }))
            self.presentViewController(offlineConfirmation, animated: true, completion: nil)
        } else { //complete installation request
            //Confirm to complete Dialog
            let completionConfirmation = UIAlertController(title: "Confirm", message: "Are you sure you want to complete installation?", preferredStyle: UIAlertControllerStyle.Alert)
            completionConfirmation.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: {
                (alert: UIAlertAction) -> Void in
                self.saveDeviceIntoDB()
                return
            }))
            completionConfirmation.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
                
                //show loading dialog
                self.view.makeToastActivityWithMessage(message: "Loading...")
                
                self.installrequestService.completeInstallationRequest(info: global.installationInfo, user: global.user) { success in
                    
                    //hide loading dialog
                    self.view.hideToastActivity()
                    
                    if success {
                        self.savedDeviceService.remove(global.installationInfo.serialNumber) {removeSuccess in
                            if removeSuccess {
                                global.installationInfo = InstallationInfo()
                            }
                        }
                        self.checkUser()
                    } else {
                        self.view.makeToast(message: self.installrequestService.errorMessage)
                    }
                }
                
                
            }))
            self.presentViewController(completionConfirmation, animated: true, completion: nil)
        }
    }
    
    func saveDeviceIntoDB() {
        self.savedDeviceService.save(global.installationInfo) {result in}
        self.checkUser()
    }
    
    func checkUser() {
        if global.user.userId > 0 {

            // Show Option Menu
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
            let goHomeAction = UIAlertAction(title: "Go Home", style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                //DashBoard is a root view, because Login View was removed view when logged in
                self.navigationController?.popToRootViewControllerAnimated(true)
                return
            })
            let goIstallationRequestsAction = UIAlertAction(title: "Go Installation Requests", style: .Default, handler: {
                (alert: UIAlertAction) -> Void in
                let installationRequest = self.storyboard?.instantiateViewControllerWithIdentifier("InstallRequest") as! InstallRequestController
                self.navigationController?.viewControllers.insert(installationRequest, atIndex: 1)
                self.navigationController?.popToViewController(installationRequest, animated: true)
                return
            })
            optionMenu.addAction(goHomeAction)
            optionMenu.addAction(goIstallationRequestsAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else {
            //go to login page
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func showTestDeviceCommand() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Back buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showTestDeviceCommand")
        //set ScrollView border
        scvMain.layer.cornerRadius = 5.0
        scvMain.layer.masksToBounds = true
        scvMain.layer.borderColor = UIColor.darkGrayColor().CGColor
        scvMain.layer.borderWidth = 1.0
        scvMain.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1) //#ebebec
        
        //load installation info
        lblAccountName.text = global.installationInfo.companyName
        
        var installer = global.user.fullName
        if countElements(installer) == 0 {
            installer = global.user.firstName + " " + global.user.lastName
        }
        lblInstaller.text = installer
        lblSerialNumber.text = global.installationInfo.serialNumber
        lblStockNumber.text = global.installationInfo.stockNumber
        lblVehicleName.text = global.installationInfo.deviceName
        lblVin.text = global.installationInfo.vin
        lblMake.text = global.installationInfo.make
        lblVehicleYear.text = global.installationInfo.year
        lblModel.text = global.installationInfo.model
        lblColor.text = global.installationInfo.color
        lblLicensePlate.text = global.installationInfo.licensePlate
        lblMarketPrice.text = "\(global.installationInfo.marketPrice)"
        
        var (failed, passed) = global.commandResults[Commands.LOCATE.rawValue]!
        lblLocateMessages.text = "\(passed) " + (passed > 1 ? "Successes" : "Success") + ", \(failed) " + (failed > 1 ? "Errors" : "Error")
        
        (failed, passed) = global.commandResults[Commands.ENABLE_LATE_PAYMENT.rawValue]!
        lblReminderOnMessages.text = "\(passed) " + (passed > 1 ? "Successes" : "Success") + ", \(failed) " + (failed > 1 ? "Errors" : "Error")
        
        (failed, passed) = global.commandResults[Commands.DISABLE_LATE_PAYMENT.rawValue]!
        lblReminderOffMessages.text = "\(passed) " + (passed > 1 ? "Successes" : "Success") + ", \(failed) " + (failed > 1 ? "Errors" : "Error")
        
        (failed, passed) = global.commandResults[Commands.ENABLE_STARTER.rawValue]!
        lblStarterEnableMessages.text = "\(passed) " + (passed > 1 ? "Successes" : "Success") + ", \(failed) " + (failed > 1 ? "Errors" : "Error")
        
        (failed, passed) = global.commandResults[Commands.DISABLE_STARTER.rawValue]!
        lblStarterDisableMessages.text = "\(passed) " + (passed > 1 ? "Successes" : "Success") + ", \(failed) " + (failed > 1 ? "Errors" : "Error")
        
        txtComment.text = global.installationInfo.comment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
