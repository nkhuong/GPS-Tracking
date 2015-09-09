//
//  DashBoardController.swift
//  Install
//
//  Created by Tran Thanh Dan on 12/31/14.
//  Copyright (c) 2014 Skypatrol LLC. All rights reserved.
//

import UIKit

class DashBoardController: UIViewController {
    
//    @IBAction func btnBeginInstall_Click(sender : AnyObject) {
//        let scanDevice = self.storyboard?.instantiateViewControllerWithIdentifier("ScanDevice") as ScanDeviceController
//        self.navigationController?.pushViewController(scanDevice, animated: true)
//    }
//    
//    @IBAction func btnInstallationRequest_Click(sender : AnyObject) {
//        let installationRequest = self.storyboard?.instantiateViewControllerWithIdentifier("InstallRequest") as InstallRequestController
//        self.navigationController?.pushViewController(installationRequest, animated: true)
//    }
//    
//    @IBAction func btnReport_Click(sender : AnyObject) {
//        let report = self.storyboard?.instantiateViewControllerWithIdentifier("Report") as ReportController
//        self.navigationController?.pushViewController(report, animated: true)
//    }
//
    
    
    @IBAction func btnInstallProfile_Click(sender: AnyObject) {
        let installerProfile = self.storyboard?.instantiateViewControllerWithIdentifier("InstallerProfile") as! InstallerController
        installerProfile.isUpdated = true
        self.navigationController?.pushViewController(installerProfile, animated: true)
    }
    
    @IBAction func btnSavedDevice_Click(sender: AnyObject) {
        let savedDevice = self.storyboard?.instantiateViewControllerWithIdentifier("SavedDevice") as! SavedDeviceController
        self.navigationController?.pushViewController(savedDevice, animated: true)
    }
    
    @IBAction func btnSetting_Click(sender: AnyObject) {
        let settings = self.storyboard?.instantiateViewControllerWithIdentifier("Settings") as! SettingController
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.viewControllers.removeAtIndex(0)
    }
}
