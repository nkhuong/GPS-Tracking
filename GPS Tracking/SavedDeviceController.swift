//
//  SavedDeviceController.swift
//  Install
//
//  Created by Nguyen Bui on 1/3/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class SavedDeviceController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    let installService = InstallationRequestService()
    let savedDeviceService = SavedDeviceService()
    
    var filteredDevices = [InstallationInfo]()
    var devices = [InstallationInfo]()
    
    func showDashBoard() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showHideDelete() {
        for cell in tableView.visibleCells {
            let realCell = cell as! InfoCustomCell
            realCell.btnDelete.hidden = !realCell.btnDelete.hidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showDashBoard")
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "showHideDelete")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showHideDelete")
        
        //hide footer view
        let tblView = UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        
        //configure search result table view
        self.searchDisplayController!.searchResultsTableView.rowHeight = 60.0
        self.searchDisplayController!.searchResultsTableView.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1)
        self.searchDisplayController!.searchResultsTableView.tableFooterView = tblView
        
        //load saved devices
        self.view.makeToastActivityWithMessage(message: "Loading...")
        
        self.savedDeviceService.getAll() { list in
            //hide loading dialog
            self.view.hideToastActivity()
            
            self.devices = list
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        //return self.devices.count
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredDevices.count
        } else {
            return self.self.devices.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> InfoCustomCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCustomCell
        cell.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1)
        
        var device: InstallationInfo
        
        //device = self.devices[indexPath.row]
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            device = self.filteredDevices[indexPath.row]
        } else {
            device = self.devices[indexPath.row]
        }
        
        cell.lblName.text = device.deviceName
        cell.lblSerial.text = device.serialNumber
        cell.btnDelete.hidden = true
        //for sending data
        cell.btnDelete.setTitle(device.serialNumber, forState: UIControlState.Disabled)
        //add event
        cell.btnDelete.addTarget(self, action: Selector("btnDelete_Click:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InfoCustomCell
        
        let serialNumber = cell.lblSerial.text!
        
        self.savedDeviceService.get(serialNumber) { info in
            if info != nil {
                global.installationInfo = info!
                
                if countElements(global.installationInfo.vin) > 0 {
                    //show option menu
                    let optionMenu = UIAlertController(title: "S/N: " + serialNumber, message: "Do you want to complete installation?", preferredStyle: .ActionSheet)
                    let installDeviceAction = UIAlertAction(title: "Re-start Installation", style: .Default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        let installDevice = self.storyboard?.instantiateViewControllerWithIdentifier("InstallDevice") as InstallDeviceController
                        self.navigationController?.pushViewController(installDevice, animated: true)
                        return
                    })
                    let goToCompletePageAction = UIAlertAction(title: "Go to complete page", style: .Default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        let completeInstallation = self.storyboard?.instantiateViewControllerWithIdentifier("CompleteInstallation") as CompleteInstallationController
                        self.navigationController?.pushViewController(completeInstallation, animated: true)
                        return
                    })
                    optionMenu.addAction(installDeviceAction)
                    optionMenu.addAction(goToCompletePageAction)
                    self.presentViewController(optionMenu, animated: true, completion: nil)
                } else {
                    if countElements(global.user.loginToken) == 0 { //not login
                        //create account?
                        self.createInstallationRequestHandler(userId: -1, serial: serialNumber, reInstalled: false)
                    } else {
                        self.createInstallationRequestHandler(userId: global.user.userId, serial: serialNumber, reInstalled: false)
                    }
                }
            }
        }
    }
    /* ======================= UI Search Bar ========================== */
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredDevices = self.devices.filter({( info: InstallationInfo) -> Bool in
            let deviceNameMatch = info.deviceName.rangeOfString(searchText)
            let serialMatch = info.serialNumber.rangeOfString(searchText)
            return deviceNameMatch != nil || (serialMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    /* ======================= UI Search Bar ========================== */
    
    func btnDelete_Click(sender: UIButton!) {
        let btn: UIButton = sender
        let serialNumber = btn.titleForState(.Disabled)!
        //confirm delete?
        let deleteConfirmation = UIAlertController(title: "S/N: " + serialNumber, message: "Would you like to delete this device?", preferredStyle: UIAlertControllerStyle.Alert)
        deleteConfirmation.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        deleteConfirmation.addAction(UIAlertAction(title: "YES", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            self.savedDeviceService.remove(serialNumber) { success in
                if success {
                    //remove item from array
                    for (index, device) in self.devices.enumerate() {
                        if device.serialNumber == serialNumber {
                            self.devices.removeAtIndex(index)
                            break
                        }
                    }
                    //refresh table view
                    self.tableView.reloadData()
                }
            }
        }))
        self.presentViewController(deleteConfirmation, animated: true, completion: nil)
    }
    //create installation request
    func createInstallationRequestHandler (userId userId: Int64, serial: String, reInstalled: Bool) {
        //show loading dialog
        self.view.makeToastActivityWithMessage(message: "Loading...")
        
        self.installService.createInstallationRequest(userId: userId, serial: serial, reInstalled: reInstalled) {info in
            //hide loading dialog
            self.view.hideToastActivity()
            
            if info != nil {
                //update info to global
                global.installationInfo = info!
                //save device
                self.savedDeviceService.save(info!) {result in}
                //move to next view
                let installDevice = self.storyboard?.instantiateViewControllerWithIdentifier("InstallDevice") as! InstallDeviceController
                self.navigationController?.pushViewController(installDevice, animated: true)
                
            } else {
                if self.installService.errorCode == Results.DEVICE_INSTALLED.rawValue {
                    //confirm to reInstalled
                    let confirm = UIAlertController(title: "Confirm", message: "This device is already installed, would you like to re-installed this device?", preferredStyle: UIAlertControllerStyle.Alert)
                    confirm.addAction(UIAlertAction(title:"NO", style: UIAlertActionStyle.Cancel, handler: nil))
                    confirm.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                        //force reInstalled
                        self.createInstallationRequestHandler(userId: userId, serial: serial, reInstalled: true)
                    }))
                    
                    self.presentViewController(confirm, animated: true, completion: nil)
                } else {
                    self.view.makeToast(message: self.installService.errorMessage)
                }
            }
        }
    }
}
