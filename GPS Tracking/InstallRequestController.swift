//
//  InstallRequestController.swift
//  Install
//
//  Created by Nguyen Bui on 1/8/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class InstallRequestController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    let installService: InstallationRequestService = InstallationRequestService()
    let savedDeviceService: SavedDeviceService = SavedDeviceService()
    var installRequests = [InstallationInfo]()
    var filteredInstallRequests = [InstallationInfo]()
    
    func showDashBoard() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showHideDelete() {
        for cell in tableView.visibleCells {
            let realCell = cell as! CustomCell
            realCell.deleteButton.hidden = !realCell.deleteButton.hidden
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        //show loading dialog
        self.view.makeToastActivityWithMessage(message: "Loading...")
        
        self.installService.getInstallationrequests(global.user.loginToken){ installationRequestList in
            //hide loading dialog
            self.view.hideToastActivity()
            
            self.installRequests = installationRequestList
            self.tableView.reloadData()
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
         return 1
    }
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
//        return self.installRequests.count
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredInstallRequests.count
        } else {
            return self.installRequests.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CustomCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        cell.backgroundColor = UIColor(red: 0.922, green: 0.922, blue: 0.925, alpha:1)
        
        var installRequest: InstallationInfo
        if tableView == self.searchDisplayController!.searchResultsTableView {
            installRequest = filteredInstallRequests[indexPath.row]
        } else {
            installRequest = installRequests[indexPath.row]
        }

        cell.deviceName.text = installRequest.deviceName
        cell.serialNumber.text = installRequest.serialNumber
        cell.deleteButton.hidden = true
        //for sending data
        cell.deleteButton.setTitle(installRequest.serialNumber, forState: UIControlState.Disabled)
        //add event
        cell.deleteButton.addTarget(self, action: Selector("deleteButton_Click:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell
        
        let serialNumber = cell.serialNumber.text!
        
        self.createInstallationRequestHandler(userId: global.user.userId, serial: serialNumber, reInstalled: false)
    }
    /* ================= UI SearchBar ==================== */
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredInstallRequests = self.installRequests.filter({( installRequest: InstallationInfo) -> Bool in
            let deviceNameMatch = installRequest.deviceName.rangeOfString(searchText)
            let serialMatch = installRequest.serialNumber.rangeOfString(searchText)
            return deviceNameMatch != nil || (serialMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    /* This block for using scope
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
    self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
    return true
    }
    */
    /* ================= UI SearchBar ==================== */
    
    //delete button clicked
    func deleteButton_Click(sender: UIButton!) {
        let btn: UIButton = sender
        let serialNumber = btn.titleForState(.Disabled)!
        //confirm delete?
        let deleteConfirmation = UIAlertController(title: "S/N: " + serialNumber, message: "Would you like to delete this device?", preferredStyle: UIAlertControllerStyle.Alert)
        deleteConfirmation.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        deleteConfirmation.addAction(UIAlertAction(title: "YES", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            //delete install request
            //show loading dialog
            self.view.makeToastActivityWithMessage(message: "Loading...")
            
            //find installation request
            var curIndex: Int = -1
            var curDevice: InstallationInfo = InstallationInfo()
            for (index, device) in self.installRequests.enumerate() {
                if device.serialNumber == serialNumber {
                    curIndex = index
                    curDevice = device
                    break
                }
            }
            if curIndex >= 0 {
                self.installService.deleteInstallationRequest(token: global.user.loginToken, installToken: curDevice.authToken) { success in
                        //hide loading dialog
                        self.view.hideToastActivity()
                        if success {
                            self.installRequests.removeAtIndex(curIndex)
                            //refresh table view
                            self.tableView.reloadData()
                        } else {
                            self.view.makeToast(message: self.installService.errorMessage)
                        }
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
}
