//
//  ViewController.swift
//  GPS Tracking
//
//  Created by Khuong Phan Nhat on 9/8/15.
//  Copyright (c) 2015 Skypatrol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txtUseName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func Login(sender: AnyObject) {
        
    }
    
    @IBAction func Registration(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtUseName.text = "kphan"
        txtPassword.text = "kphan123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

