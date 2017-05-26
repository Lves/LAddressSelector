//
//  NSString+Extension.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func getButtonWidth(fontSize:CGFloat ,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = self
        let size = CGSizeMake(CGFloat.max, height)
        let dic = NSDictionary(object: UIFont.systemFontOfSize(fontSize), forKey: NSFontAttributeName)
        let strSize = statusLabelText.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin,.TruncatesLastVisibleLine,.UsesFontLeading], attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
    }
}
