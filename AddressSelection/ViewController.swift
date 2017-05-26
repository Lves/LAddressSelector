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
    lazy var chooseAddresView:ChooseAddressView = {
        let chooseView = ChooseAddressView.instanceFromNib()
        chooseView.frame = CGRect(x: 0, y:self.view.frame.height-350 , width: self.view.frame.width, height: 350)
        chooseView.hidden = true
        UIApplication.sharedApplication().keyWindow?.addSubview(chooseView)
        return chooseView
    }()
    lazy var coverView: UIView = {
        let cover = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        cover.backgroundColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        cover.hidden = true
        UIApplication.sharedApplication().keyWindow?.addSubview(cover)
        return cover
    }()
    
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
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCover))
//        coverView.addGestureRecognizer(tap)
    }

//    func tapCover()  {
//        coverView.hidden = true
//        chooseAddresView.hidden = true
//        
//    }

    @IBAction func selectButtonClick(sender: AnyObject) {
//        coverView.hidden = false
//        chooseAddresView.hidden = false
        addressView.showView()
        
    }
    
    deinit {
//        chooseAddresView.removeFromSuperview()
//        coverView.removeFromSuperview()
    }

}

