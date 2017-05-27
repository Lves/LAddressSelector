//
//  ViewController.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnSelect: UIButton!
    lazy var addressView:LoanAddressView = {
        let keyWindowFrame = UIApplication.sharedApplication().keyWindow?.frame ?? CGRectZero
        let addressV = LoanAddressView(frame: CGRect(x: 0, y: 0, width: keyWindowFrame.size.width, height: keyWindowFrame.size.height))
        addressV.resultBlock = { address in
            self.btnSelect.setTitle(address ?? "选择", forState: .Normal)
        }
        return addressV
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
    }

    @IBAction func selectButtonClick(sender: AnyObject) {
        addressView.showView()
    }
    deinit {
    }

}

