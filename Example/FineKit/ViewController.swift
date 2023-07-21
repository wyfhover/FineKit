//
//  ViewController.swift
//  FineKit
//
//  Created by wyfhover@163.com on 06/30/2023.
//  Copyright (c) 2023 wyfhover@163.com. All rights reserved.
//

import UIKit
import FineKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var bytes: [UInt8] = [0xAA, 0xBB]
        print(bytes.fk.hexString)
        print(bytes.fk[w: 0])
        
        let b = 1.1
//        print(b.toBytes())
        print(b.fk.toBytes())
        
        
        let data = Data(bytes: bytes, count: bytes.count)
        print(data.fk.hexadecimal(","))
        
        let c: Int32 = 256
        print(c.fk.toBytes())
        
        let v = UIButton()
        
//        UIColor.fk.
        
        print("end")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

