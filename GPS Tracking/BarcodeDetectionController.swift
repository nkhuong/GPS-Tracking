//
//  BarcoceScanningController.swift
//  Install
//
//  Created by Pham Dai Xuan on 1/11/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeDetectionControllerDelegate {
    func barcodeDetectionDidFinish(controller: BarcodeDetectionController)
}

class BarcodeDetectionController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var delegate:BarcodeDetectionControllerDelegate? = nil
    var prefix : String = ""
    var barcode: String = ""
    var navigatorHiddenState: Bool! = false
    
    let objectTypes : [NSString] = [AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode,
        AVMetadataObjectTypeInterleaved2of5Code,
        AVMetadataObjectTypeITF14Code,
        AVMetadataObjectTypeDataMatrixCode ]
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    @IBOutlet weak var flashLightLabel: UILabel!
    @IBOutlet weak var flashLightSwitch: UISwitch!
    //    @IBOutlet weak var quitButton: UIButton!
    
    //    @IBAction func quitButtonPressed(sender: AnyObject) {
    //        turnFlashLight(false)
    //        if self.captureSession?.running == true {
    //            self.captureSession?.stopRunning()
    //        }
    //
    //
    //        self.navigationController?.navigationBar.hidden = self.navigatorHiddenState
    //        self.navigationController?.popViewControllerAnimated(true)
    //        if (delegate != nil) {
    //            delegate!.barcodeDetectionDidFinish(self)
    //        }
    //        //self.dismissViewControllerAnimated(true, nil)
    //    }
    
    @IBAction func flashLightSwitchValesChanged(sender: AnyObject) {
        turnFlashLight(self.flashLightSwitch.on)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigatorHiddenState = self.navigationController?.navigationBar.hidden
        self.navigationController?.navigationBar.hidden = true
        
        //        self.quitButton.setTitle(self.prefix + self.barcode, forState: UIControlState.Normal)
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput.deviceInputWithDevice(captureDevice)
        } catch var error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        captureMetadataOutput.metadataObjectTypes = self.objectTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        //orientation
        let deviceOrientation = UIDevice.currentDevice().orientation
        if deviceOrientation == UIDeviceOrientation.Portrait {
            self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        }
        else if deviceOrientation == UIDeviceOrientation.PortraitUpsideDown {
            self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        }
        else if deviceOrientation == UIDeviceOrientation.LandscapeLeft {
            self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
        }
        else if deviceOrientation == UIDeviceOrientation.LandscapeRight {
            self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
        }
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        //Turn flashlight ON
        //        self.flashLightSwitch.setOn(true, animated: true)
        //        turnFlashLight(true)
        
        // Move the message label to the top view
        view.bringSubviewToFront(self.flashLightSwitch)
        //        view.bringSubviewToFront(self.quitButton)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil, completion: {context in
            self.videoPreviewLayer?.frame.size = size
            let deviceOrientation = UIDevice.currentDevice().orientation
            if deviceOrientation == UIDeviceOrientation.Portrait {
                self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            }
            else if deviceOrientation == UIDeviceOrientation.PortraitUpsideDown {
                self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            }
            else if deviceOrientation == UIDeviceOrientation.LandscapeLeft {
                self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            }
            else if deviceOrientation == UIDeviceOrientation.LandscapeRight {
                self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            }
        })
        
    }
    
    func turnFlashLight(on: Bool) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
            } catch _ {
            }
            if on == false {
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                }
            }
            else {
                if (device.torchMode == AVCaptureTorchMode.Off) {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    } catch _ {
                    }
                }
            }
            device.unlockForConfiguration()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPrefix(prefix: String) {
        self.prefix = prefix
        //        self.updateQuitButton()
    }
    
    //    func updateQuitButton() {
    //        if self.quitButton != nil {
    //            self.quitButton.setTitle(self.prefix + self.barcode, forState: UIControlState.Normal)
    //        }
    //    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.barcode = ""
        //        self.updateQuitButton()
        if self.captureSession?.running == false {
            qrCodeFrameView?.frame = CGRectZero
            self.captureSession?.startRunning()
            turnFlashLight(self.flashLightSwitch.on)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            self.barcode = ""
            //            self.updateQuitButton()
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        for objectType in self.objectTypes {
            if objectType == metadataObj.type {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
                qrCodeFrameView?.frame = barCodeObject.bounds;
                
                if metadataObj.stringValue != nil {
                    self.barcode = metadataObj.stringValue
                    //                    self.updateQuitButton()
                    self.captureSession?.stopRunning()
                    
                    //dismiss view
                    turnFlashLight(false)
                    self.navigationController?.navigationBar.hidden = self.navigatorHiddenState
                    self.navigationController?.popViewControllerAnimated(true)
                    if (delegate != nil) {
                        delegate!.barcodeDetectionDidFinish(self)
                    }
                    
                    return
                }
            }
        }
    }
}