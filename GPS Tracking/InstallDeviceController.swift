//
//  InstallDeviceController.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/3/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit

class InstallDeviceController: TextFieldScrollingController, BarcodeDetectionControllerDelegate {
    @IBOutlet var accountNameTextField: UITextField!
    @IBOutlet var serialTextField: UITextField!
    @IBOutlet var stockNumberTextField: UITextField!
    @IBOutlet var vinTextField: UITextField!
    @IBOutlet var vehicleNameTextField: UITextField!
    @IBOutlet var vehicleMakeTextField: UITextField!

    @IBOutlet var vehicleYearTextField: UITextField!
    @IBOutlet var vehicleModelTextField: UITextField!
    @IBOutlet var vehicleColorTextField: UITextField!
    @IBOutlet var licensePlateTextField: UITextField!
    @IBOutlet var marketPriceTextField: UITextField!
    
    var scanStockNumberBarcode: Bool = false
    var scanVINBarcode: Bool = false
    
    var vinService: VinService = VinService()
    var savedDeviceService = SavedDeviceService()
    var currentVin = ""
    
    @IBAction func btnContinue_Click(sender : AnyObject) {
        showTestDeviceCommand()
    }

    @IBAction func stockNumberScanButtonPressed(sender: AnyObject) {
        scanStockNumberBarcode = true
        let barcodeDetectionController = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeDetection") as! BarcodeDetectionController
//        barcodeDetectionController.setPrefix("Stock#: ")
        barcodeDetectionController.delegate = self
        self.navigationController?.pushViewController(barcodeDetectionController, animated: true)
    }
    
    @IBAction func vinScanButtonPressed(sender: AnyObject) {
        scanVINBarcode = true
        let barcodeDetectionController = self.storyboard?.instantiateViewControllerWithIdentifier("BarcodeDetection") as! BarcodeDetectionController
//        barcodeDetectionController.setPrefix("VIN: ")
        barcodeDetectionController.delegate = self
        self.navigationController?.pushViewController(barcodeDetectionController, animated: true)
    }
    
    func barcodeDetectionDidFinish(controller: BarcodeDetectionController) {
        if scanStockNumberBarcode == true {
            self.stockNumberTextField.text = controller.barcode
            
            // Assign stock number to vehicle name
             let deviceName = vehicleNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if !deviceName.isEmpty {
                self.vehicleNameTextField.text = controller.barcode
            }
            scanStockNumberBarcode = false
        }
        else if scanVINBarcode == true {
            // Get the last 17 digits of VIN
            if countElements(controller.barcode) > 17 {
                let startIndex = controller.barcode.startIndex.advancedBy((countElements(controller.barcode) - 17))
                controller.barcode = controller.barcode.substringFromIndex(startIndex)
            }

            // Showing on the scene
            self.vinTextField.text = controller.barcode
            scanVINBarcode = false
            
            // Call VIN decode services
            self.vinDecoder(controller.barcode)
        }
    }
    
    func vinDecoder(barcode: String) {
        if countElements(barcode) > 0 && barcode != currentVin {
            //show loading dialog
            self.view.makeToastActivityWithMessage(message: "Loading...")
            currentVin = barcode
            self.vinService.decodeVIN(barcode) { installationInfo in
                
                //hide loading dialog
                self.view.hideToastActivity()
                
                if installationInfo != nil {
                    self.vehicleMakeTextField.text  = installationInfo!.make
                    self.vehicleYearTextField.text  = installationInfo!.year
                    self.vehicleModelTextField.text = installationInfo!.model
                    self.vehicleColorTextField.text = installationInfo!.color
                } else {
                    self.vehicleMakeTextField.text  = ""
                    self.vehicleYearTextField.text  = ""
                    self.vehicleModelTextField.text = ""
                    self.vehicleColorTextField.text = ""
                    self.view.makeToast(message: self.vinService.errorMessage)
                    self.vinTextField.becomeFirstResponder()
                }
            }
        }
    }
    
    func showScanDevice() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showTestDeviceCommand() {
        
        let companyName = accountNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let serial = serialTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let stock = stockNumberTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let deviceName = vehicleNameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let vin = vinTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let make = vehicleMakeTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let year = vehicleYearTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let model = vehicleModelTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let color = vehicleColorTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let plateNo = licensePlateTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let marketPrice = marketPriceTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        //check validate
        if countElements(stock) > 50 {
            self.view.makeToast(message: "Stock number is too long!")
            self.stockNumberTextField.becomeFirstResponder()
            return
        }
        if countElements(deviceName) > 50 {
            self.view.makeToast(message: "Vehicle name is too long!")
            self.vehicleNameTextField.becomeFirstResponder()
            return
        }
        if vin.isEmpty {
            self.view.makeToast(message: "VIN number is required!")
            self.vinTextField.becomeFirstResponder()
            return
        } else if countElements(vin) != 17 {
            self.view.makeToast(message: "VIN number must be 17 digits!")
            self.vinTextField.becomeFirstResponder()
            return
        }
        
        if make.isEmpty {
            self.view.makeToast(message: "Make is required!")
            self.vehicleMakeTextField.becomeFirstResponder()
            return
        } else if countElements(make) > 30 {
            self.view.makeToast(message: "Make value is too long!")
            self.vehicleMakeTextField.becomeFirstResponder()
            return
        }
        
        if year.isEmpty {
            self.view.makeToast(message: "Vehicle year is required!")
            self.vehicleYearTextField.becomeFirstResponder()
            return
        } else if countElements(year) > 50 {
            self.view.makeToast(message: "Vehicle year is invalid!")
            self.vehicleYearTextField.becomeFirstResponder()
            return
        }
        
        if model.isEmpty {
            self.view.makeToast(message: "Model is required!")
            self.vehicleModelTextField.becomeFirstResponder()
            return
        } else if countElements(model) > 30 {
            self.view.makeToast(message: "Model is too long!")
            self.vehicleModelTextField.becomeFirstResponder()
            return
        }
        /*
        if color.isEmpty {
            self.view.makeToast(message: "Color is required!")
            self.vehicleColorTextField.becomeFirstResponder()
            return
        } else */
        if countElements(color) > 100 {
            self.view.makeToast(message: "Color is too long!")
            self.vehicleColorTextField.becomeFirstResponder()
            return
        }
        
        if countElements(plateNo) > 10 {
            self.view.makeToast(message: "License plate is invalid!")
            self.licensePlateTextField.becomeFirstResponder()
            return
        }
        
        //save info
        
        var info = InstallationInfo()
        
        info.companyName = companyName
        info.serialNumber = serial
        info.stockNumber = stock
        info.deviceName = deviceName
        info.vin = vin
        info.make = make
        info.year = year
        info.model = model
        info.color = color
        info.licensePlate = plateNo
        let d = (marketPrice as NSString).doubleValue
        info.marketPrice = d
        //update to global variable
        global.installationInfo.updateInfo(info)
        //save device to DB
        self.savedDeviceService.save(info) {result in}
        
        //move to test command
        let testDeviceCommand = self.storyboard?.instantiateViewControllerWithIdentifier("TestDeviceCommand") as! TestDeviceCommandController
        self.navigationController?.pushViewController(testDeviceCommand, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showScanDevice")
        
        let rightItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "next_button"), style: UIBarButtonItemStyle.Plain, target: self, action: "showTestDeviceCommand")
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        //add event when VIN text Field ends editing
        vinTextField.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: UIControlEvents.EditingDidEnd)
        
        //load installation info
        self.accountNameTextField.text = global.installationInfo.companyName
        self.serialTextField.text = global.installationInfo.serialNumber
        self.stockNumberTextField.text = global.installationInfo.stockNumber
        self.vehicleNameTextField.text = global.installationInfo.deviceName
        self.vinTextField.text = global.installationInfo.vin
        self.vehicleMakeTextField.text = global.installationInfo.make
        self.vehicleYearTextField.text = global.installationInfo.year
        self.vehicleModelTextField.text = global.installationInfo.model
        self.vehicleColorTextField.text = global.installationInfo.color
        self.licensePlateTextField.text = global.installationInfo.licensePlate
        self.marketPriceTextField.text = "\(global.installationInfo.marketPrice)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        if textField == vinTextField {
            // Get the last 17 digits of VIN
            var barcode = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if countElements(barcode) > 17 {
                let startIndex = barcode.startIndex.advancedBy((countElements(barcode) - 17))
                barcode = barcode.substringFromIndex(startIndex)
                textField.text = barcode
            }
            
            self.vinDecoder(barcode)
        }
    }
}
