//
//  ChooseAddressView.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import MJExtension
class ChooseAddressView: UIView,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var vernierView: UIView!
    
    var tableViews:[UITableView] = []
    @IBOutlet var barItems:[UIButton]!
    var provinceArray: [Province]?  //数据源
    var currentProvince:Province?   //当前省份
    var currentCity:City?           //当前城市
    var currentArea:String?         //当前城区
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func instanceFromNib() -> ChooseAddressView {
        let chooseAddressView = NSBundle.mainBundle().loadNibNamed("ChooseAddressView", owner: nil, options: nil)![0] as! ChooseAddressView
        chooseAddressView.setUp()
        return chooseAddressView
    }
    func setUp()  {
        loadCityies() //加载数据
        //初始化Scroll的第一个tableView
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.frame.width, height: 0)
        let tableView = getTableView()
        tableView.frame = CGRect(x: (CGFloat (tableViews.count))*self.frame.width, y: 0, width: self.frame.width, height: self.frame.height-90)
        tableViews.append(tableView)
        scrollView.addSubview(tableView)
        tableView.reloadData()
        //初始化item
        createBarItem("请选择",index: 0)
        
    }
    func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView  = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
    func loadCityies()  {
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "plist")
        let dic = NSArray(contentsOfFile: path!)
        provinceArray = (Province.mj_objectArrayWithKeyValuesArray(dic).copy() as? Array<Province>)!
    }
    
    
    //MARK: - TableView delegate&datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViews.indexOf(tableView) == 0 { //省份
            return provinceArray?.count ?? 0
        }else if tableViews.indexOf(tableView) == 1 { //城市
            return currentProvince?.cities?.count ?? 0
        }else if tableViews.indexOf(tableView) == 2 { //地区
            return currentCity?.areas?.count ?? 0
        }
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = "\(tableViews.indexOf(tableView) ?? 0)"
        
        if tableViews.indexOf(tableView) == 0 { //省份
            let pro:Province? = provinceArray?[indexPath.row]
            cell?.textLabel?.text = pro?.state ?? ""
        }else if tableViews.indexOf(tableView) == 1 { //城市
            let city:City? = currentProvince?.cities?[indexPath.row]
            cell?.textLabel?.text = city?.city ?? ""
        }else if tableViews.indexOf(tableView) == 2 { //城区
            cell?.textLabel?.text = currentCity?.areas?[indexPath.row]
        }
        return cell!
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let index = tableViews.indexOf(tableView)
        if index == 0 { //省份
            currentProvince = provinceArray?[indexPath.row]
            let item = barItems[0]
            item.titleLabel?.text = self.currentProvince?.state ?? ""
            item.setTitle(self.currentProvince?.state ?? "", forState: .Normal)
            createBarItem("请选择" , index: 1)
        }else if index == 1 { //城市
            currentCity = currentProvince?.cities?[indexPath.row]
            let item = barItems[1]
            item.titleLabel?.text = self.currentCity?.city ?? ""
            item.setTitle(self.currentCity?.city ?? "", forState: .Normal)
            createBarItem("请选择" , index: 2)
        }else if index == 2 { //城区
            currentArea = currentCity?.areas?[indexPath.row]
            let item = barItems[2]
            item.titleLabel?.text = self.currentArea
            item.setTitle(self.currentArea, forState: .Normal)
            return indexPath
        }
        let nextIndex = (index!+1)
        if tableViews.count == nextIndex{
            addNextTableView()
        }
        let tableView = tableViews[nextIndex]
        tableView.reloadData()
        return indexPath
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let index = tableViews.indexOf(tableView)
        let nextIndex = (index ?? 0)+1
        if index == 2 {
            return
        }
        scrollTableView(nextIndex)
    }
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offset = scrollView.contentOffset.x/scrollView.frame.width
            moveVernier(Int(offset))
        }
    }
    
    
    
    //MARK: - action
    @IBAction func itemClick(sender: UIButton) {
        let index = sender.tag - 1000
        scrollTableView(index)
        
    }

    
    //MARK: private 
    func addNextTableView()  {
        let tableView = getTableView()
        tableViews.append(tableView)
        tableView.frame = CGRect(x: (CGFloat (tableViews.count-1))*self.frame.width, y: 0, width: self.frame.width, height: self.frame.height-90)
        scrollView.contentSize = CGSize(width: self.frame.width+scrollView.contentSize.width, height: 0)
        scrollView.addSubview(tableView)
        tableView.reloadData()
    }
    
    func createBarItem(title:String,index:Int) {
        UIView.animateWithDuration(0.5) {
            let item = self.barItems[index]
            item.hidden = false
            item.titleLabel?.text = title
            item.setTitle(title, forState: .Normal)
            //删除后边的
            for nextIndex in (index+1..<self.barItems.count).reverse() {
                let nextItem = self.barItems[nextIndex]
                nextItem.hidden = true
            }
        }
    }
    func scrollTableView(nextIndex:Int)  {
        let x = (CGFloat (nextIndex))*self.frame.width
        let point = CGPoint(x:x , y: 0)
        scrollView.setContentOffset(point, animated: true)
        moveVernier(nextIndex)
    }
    //游标移动
    func moveVernier(nextIndex:Int)  {
        let item = barItems[nextIndex]
//        UIView.animateWithDuration(0.4) {
//            print("滑动到\(item.tag):  \(item.center.x)")
//            
//        }
//        print("\(nextIndex)  : \()")
        UIView.animateWithDuration(0.4, delay: 0, options: [.CurveLinear,.AllowUserInteraction], animations: {
            self.vernierView.bounds = CGRect(x: 0 , y: 0, width: item.frame.width, height: self.vernierView.frame.height)
            self.vernierView.center = CGPointMake(item.center.x, self.vernierView.center.y)
        }, completion: nil)
        
    }
    
    
}
