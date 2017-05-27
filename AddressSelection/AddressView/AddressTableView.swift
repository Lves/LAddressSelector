//
//  AddressTableView.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/25.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
struct LoanConst {
    static let ScreenW = UIScreen.mainScreen().bounds.size.width
    static let ScreenH = UIScreen.mainScreen().bounds.size.height
    static let IPHONE6_SIZE = UIScreen.mainScreen().bounds.size.width/375.0
}

class AddressTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    var indexRow:String?
    var datas:[AnyObject]?
    var tableView:UITableView?
    var block:((selectedIndex:Int,content:String,nextArray:[AnyObject]?)-> Void)?
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect , params:[AnyObject]?) {
        super.init(frame: frame)
        datas = params
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.separatorStyle = .None
        self.addSubview(tableView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TableView delegate & datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CityCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "CityCell")
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
        }
        if let province = datas?[indexPath.row] as? Province {
            cell?.textLabel?.text = province.state ?? ""
        }else if let city = datas?[indexPath.row] as? City {
            cell?.textLabel?.text = city.city ?? ""
        }else if let str = datas?[indexPath.row] as? String{
            cell?.textLabel?.text = str
        }
        
        if let index = indexRow where Int(index) == indexPath.row {
            cell?.textLabel?.textColor = UIColor.redColor()
        }else {
            cell?.textLabel?.textColor = UIColor.blackColor()
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        indexRow = "\(indexPath.row)"
        tableView.reloadData()
        var content:String?
        var nextArray:[AnyObject]?
        if let province = datas?[indexPath.row] as? Province {
            content = province.state ?? ""
            nextArray = province.cities
        }else if let city = datas?[indexPath.row] as? City {
            content = city.city ?? ""
            nextArray = city.areas
        }else if let str = datas?[indexPath.row] as? String{
            content = str
        }
        block?(selectedIndex:indexPath.row,content:content ?? "",nextArray:nextArray)
    }
 

}
