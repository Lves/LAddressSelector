//
//  LoanAddressView.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/25.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit


struct LAddressConst {
    static let kTopLabelMargin:CGFloat = 15
    static let kFontSize:CGFloat = 15
}

class LoanAddressView: UIView,UIScrollViewDelegate {

    var resultBlock:((selectedAddress:String?)-> Void)?
    
    var datasArr:[Province]?
    var datasArr1:[City]?
    var datasArr2:[String]?
    
    var myView:UIView!
    var fatherView:UIView?
    var selectLabel:UILabel!
    var redLineView:UIView!
    var scrollView:UIScrollView!
    var tableview1:AddressTableView?
    var _tableview2:AddressTableView?
    var tableview2:AddressTableView?{
        get{
            if _tableview2 == nil {
                _tableview2 = getTableView2()
            }
            return _tableview2
        }
        set{
            _tableview2 = newValue
        }
    }
    
    var _tableview3:AddressTableView?
    var tableview3:AddressTableView?{
        get{
            if _tableview3 == nil {
                _tableview3 = getTableView3()
            }
            return _tableview3
        }
        set{
            _tableview3 = newValue
        }
    }
    
    //耳机城市label
    var _cityLabel:UILabel?
    var cityLabel:UILabel? {
        get{
            if _cityLabel == nil {
                _cityLabel = getCityLabel()
            }
            return _cityLabel
        }
        set{
            _cityLabel = newValue
        }
    }
    
    //记录点击的第一个省份
    var oneProvince:Province?
    //记录点击的第二个城市
    var twoCity:City?
    
    
    let iPhone6Size = LoanConst.IPHONE6_SIZE
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        let tapView = UIView(frame: CGRect(x: 0, y: 0, width: LoanConst.ScreenW, height: LoanConst.ScreenH-400*iPhone6Size))
        tapView.userInteractionEnabled = true
        self.addSubview(tapView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.tapClick))
        tapView.addGestureRecognizer(tap)
        //获取数据源
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "plist")
        let dic = NSArray(contentsOfFile: path!)
        datasArr = (Province.mj_objectArrayWithKeyValuesArray(dic).copy() as? Array<Province>)!
        
        myView = UIView(frame: CGRect(x: 0, y: LoanConst.ScreenH, width: LoanConst.ScreenW, height: 400*iPhone6Size))
        myView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(myView!)
        
        addTitleView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
    func showView() {
        UIView.animateWithDuration(0.5) { 
            self.myView.frame = CGRect(x: 0, y: LoanConst.ScreenH - 400*self.iPhone6Size, width: LoanConst.ScreenW, height: 400*self.iPhone6Size)
        }
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
  
    
    //MARK: ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/LoanConst.ScreenW
        if page == 0 {
            let w = self.provinceLabel.text?.getButtonWidth(LAddressConst.kFontSize, height: 30*self.iPhone6Size) ?? 0
            UIView.animateWithDuration(0.5, animations: {
                self.redLineView.frame = CGRect(x: LAddressConst.kTopLabelMargin, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
            })
        }else if page == 1{
            if let cityLabel = self.cityLabel {
                let x = CGRectGetMaxX(provinceLabel.frame ?? CGRectZero)+LAddressConst.kTopLabelMargin
                let w = cityLabel.text?.getButtonWidth(LAddressConst.kFontSize, height: 30*self.iPhone6Size) ?? 0
                UIView.animateWithDuration(0.5, animations: {
                    self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
                })
            }else {
                let x = CGRectGetMaxX(provinceLabel.frame ?? CGRectZero)+LAddressConst.kTopLabelMargin
                UIView.animateWithDuration(0.5, animations: {
                    self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: 45, height: 1)
                })
            }
        }else {
            let w = selectLabel.frame.size.width //text?.getButtonWidth(LAddressConst.kFontSize, height: 30*LoanConst.IPHONE6_SIZE) ?? 0
            UIView.animateWithDuration(0.5, animations: {
                self.redLineView.frame = CGRect(x: CGRectGetMinX(self.selectLabel.frame), y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
            })
        }
    }
    //MARK: private
    
    func addTitleView()  {
        
        //1.0 Title
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: LoanConst.ScreenW, height: 55*iPhone6Size))
        titleLable.text = "所在地区"
        titleLable.textColor = UIColor.blackColor()
        titleLable.textAlignment = .Center
        myView?.addSubview(titleLable)
        //2.0 关闭按钮
        let button = UIButton(frame: CGRect(x: LoanConst.ScreenW - 55*LoanConst.IPHONE6_SIZE, y: 0, width: 55*iPhone6Size, height: 55*iPhone6Size))
        button.setImage(UIImage(named: "CloseBtn"), forState: .Normal)
        button.addTarget(self, action: #selector(LoanAddressView.tapClick), forControlEvents: .TouchUpInside)
        myView?.addSubview(button)
        //3.0 SelectLable
        selectLabel = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(titleLable.frame), width: 75, height: 30*iPhone6Size))
        selectLabel.textColor = UIColor.redColor()
        selectLabel.textAlignment = .Center
        selectLabel.font = UIFont.systemFontOfSize(LAddressConst.kFontSize)
        selectLabel.userInteractionEnabled = true
        selectLabel.text = "请选择"
        myView?.addSubview(selectLabel!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.selectLabelTapClick))
        selectLabel?.addGestureRecognizer(tap)
        //4.0 LineView 
        let lineView = UIView(frame: CGRect(x: 0, y: CGRectGetMaxY(selectLabel.frame), width: LoanConst.ScreenW, height: 1))
        lineView.backgroundColor = UIColor.grayColor()
        myView?.addSubview(lineView)
        //5.0 RedLineView
        redLineView = UIView(frame: CGRect(x: CGRectGetMinX(selectLabel.frame)+LAddressConst.kTopLabelMargin, y: CGRectGetMaxY(selectLabel.frame), width: 45, height: 1))
        redLineView.backgroundColor = UIColor.redColor()
        myView?.addSubview(redLineView)
        //6.0 ScrollView
        let sH = myView.frame.size.height - CGRectGetMaxY(redLineView.frame)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: CGRectGetMaxY(redLineView.frame), width: LoanConst.ScreenW, height: sH))
        scrollView.contentSize = CGSize(width: LoanConst.ScreenW, height: scrollView.frame.size.height)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        myView.addSubview(scrollView)
        //7.0 第一个TableView
        let scrollH = scrollView.frame.size.height
        
        tableview1 = AddressTableView(frame: CGRect(x: 0, y: 0, width: LoanConst.ScreenW, height: scrollH), params: datasArr)
        tableview1?.block = {[weak self] selectedIndex in
            let iPhone6_size  = self?.iPhone6Size ?? 1
            self?.cityLabel?.removeFromSuperview()
            self?.cityLabel = nil
            self?.oneProvince = self?.datasArr?[selectedIndex]
            let pWidth = self?.oneProvince?.state?.getButtonWidth(LAddressConst.kFontSize, height: 30*iPhone6_size) ?? 0
            self?.provinceLabel.frame = CGRect(x: 0, y: 55*iPhone6_size, width: 30+pWidth, height: 30*iPhone6_size)
            self?.selectLabel.text = "请选择"
            UIView.animateWithDuration(0.5, animations: {
                self?.selectLabel.frame = CGRect(x: CGRectGetMaxX(self?.provinceLabel.frame ?? CGRectZero), y: CGRectGetMaxY(titleLable.frame), width: 75, height: 30*iPhone6_size)
                let redX = CGRectGetMinX(self?.selectLabel?.frame ?? CGRectZero) + LAddressConst.kTopLabelMargin
                self?.redLineView.frame = CGRect(x: redX, y: CGRectGetMaxY(self?.selectLabel.frame ?? CGRectZero), width: 45, height: 1)
            } ,completion: { _ in
                self?.provinceLabel.text = self?.oneProvince?.state ?? ""
            })
            self?.scrollView.contentSize = CGSize(width: LoanConst.ScreenW*2, height: scrollH)
            self?.tableview2?.removeFromSuperview()
            self?.tableview2 = nil
            self?.tableview3?.removeFromSuperview()
            self?.tableview3 = nil
            self?.datasArr1 = self?.oneProvince?.cities
            self?.tableview2?.hidden = false
            self?.scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW,y: 0), animated: true)
            
            
        }
        scrollView.addSubview(tableview1!)
    }
    ///省份label
    lazy var provinceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(LAddressConst.kFontSize)
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        self.myView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.provinceLabelTapClick))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    func getCityLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(LAddressConst.kFontSize)
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        label.backgroundColor = UIColor.whiteColor()
        self.myView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.cityLabelTapClick))
        label.addGestureRecognizer(tap)
        return label
    }
    
    
    func getTableView2() -> AddressTableView {
        let scrollH = scrollView.frame.size.height
        let tableview = AddressTableView(frame: CGRect(x: LoanConst.ScreenW, y: 0, width: LoanConst.ScreenW, height: scrollH), params: self.datasArr1)
        tableview.block = {[weak self] selectedIndex in
            let iPhone6_size  = self?.iPhone6Size ?? 1
            self?.twoCity = self?.datasArr1?[selectedIndex]
            
            let wCityLabel = self?.twoCity?.city?.getButtonWidth(LAddressConst.kFontSize, height: 30*iPhone6_size) ?? 0
            self?.cityLabel?.frame = CGRect(x: CGRectGetMaxX((self?.provinceLabel.frame ?? CGRectZero)), y: 55*iPhone6_size, width: wCityLabel+30, height: 30*iPhone6_size)
            UIView.animateWithDuration(0.5, animations: {
                self?.selectLabel.frame = CGRect(x: CGRectGetMaxX(self?.cityLabel?.frame ?? CGRectZero), y: CGRectGetMinY(self?.provinceLabel.frame ?? CGRectZero), width: 75, height: 30*iPhone6_size)
                let x = CGRectGetMinX(self?.selectLabel?.frame ?? CGRectZero) + LAddressConst.kTopLabelMargin
                self?.redLineView.frame = CGRect(x:x , y: CGRectGetMaxY(self?.selectLabel.frame ?? CGRectZero), width: 45, height: 1)
                self?.cityLabel?.text = self?.twoCity?.city ?? ""
            } ,completion: { _ in
                self?.selectLabel.text = "请选择"
                
            })
            self?.scrollView.contentSize = CGSize(width: LoanConst.ScreenW*3, height: scrollH)
            self?.scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW*2,y: 0), animated: true)
            self?.datasArr2 = self?.twoCity?.areas
            
            self?.tableview3?.removeFromSuperview()
            self?.tableview3 = nil
            self?.tableview3?.hidden = false
        }
        scrollView.addSubview(tableview)
        return tableview
    }
    func getTableView3() -> AddressTableView {
        let scrollH = scrollView.frame.size.height
        let tableview = AddressTableView(frame: CGRect(x: LoanConst.ScreenW * 2, y: 0, width: LoanConst.ScreenW, height: scrollH), params: self.datasArr2)
        tableview.block = {[weak self] selectedIndex in
            let iP6Size = self?.iPhone6Size ?? 1
            let qu = self?.datasArr2?[selectedIndex] ?? ""
            let quW = qu.getButtonWidth(LAddressConst.kFontSize, height: 30*iP6Size)
            let selectX = CGRectGetMaxX(self?.cityLabel?.frame ?? CGRectZero) + LAddressConst.kTopLabelMargin
            
            UIView.animateWithDuration(0.5, animations: {
                self?.selectLabel.frame = CGRect(x: selectX, y: CGRectGetMinY(self?.provinceLabel.frame ?? CGRectZero), width: quW, height: 30*iP6Size)
                let w = qu.getButtonWidth(LAddressConst.kFontSize, height: 30*LoanConst.IPHONE6_SIZE) ?? 0
                self?.redLineView.frame = CGRect(x:selectX , y: CGRectGetMaxY(self?.selectLabel.frame ?? CGRectZero), width: w, height: 1)
            } ,completion: { _ in
                self?.selectLabel.text = qu
            })
            
            //通知外部
            let address = "\(self?.oneProvince?.state ?? "") \(self?.twoCity?.city ?? "") \(qu)"
            print(address)
            self?.tapClick()
            self?.resultBlock?(selectedAddress: address)
        }
        scrollView.addSubview(tableview)
        return tableview
    }

    
    
    //MARK:  Action
    func tapClick()  {
        UIView.animateWithDuration(0.5, animations: { 
            self.myView.frame = CGRect(x: 0, y: LoanConst.ScreenH, width: LoanConst.ScreenW, height: 400*LoanConst.IPHONE6_SIZE)
        }) { (scucess) in
            self.removeFromSuperview()
        }
    }
    //点击区
    func selectLabelTapClick()  {
        let x = CGRectGetMaxX(cityLabel?.frame ?? CGRectZero)+LAddressConst.kTopLabelMargin
        let w = selectLabel.text?.getButtonWidth(LAddressConst.kFontSize, height: 30*iPhone6Size) ?? 0
        UIView.animateWithDuration(0.5, animations: {
            self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
        })
        if self.cityLabel != nil {
            scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW * 2,y: 0), animated: true)
        }else {
            scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW , y: 0), animated: true)
        }
    }
    //点击省
    func provinceLabelTapClick()  {
        let w = provinceLabel.text?.getButtonWidth(LAddressConst.kFontSize, height: 30*iPhone6Size) ?? 0
        UIView.animateWithDuration(0.5, animations: {
            self.redLineView.frame = CGRect(x: LAddressConst.kTopLabelMargin, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
        })
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    //点击市
    func cityLabelTapClick()  {
        let x = CGRectGetMaxX(provinceLabel.frame)+LAddressConst.kTopLabelMargin
        let w = cityLabel?.text?.getButtonWidth(LAddressConst.kFontSize, height: 30*iPhone6Size) ?? 0
        UIView.animateWithDuration(0.5, animations: {
            self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: 1)
        })
        scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW , y: 0), animated: true)
    }

}
