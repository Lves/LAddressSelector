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
    static let kDefaultContent:String = "请选择"
    static let kAnimateDuration:NSTimeInterval = 0.5
    static let kSelectLabelDefaultW:CGFloat = 75
    static let kLabelH:CGFloat = 55*LoanConst.IPHONE6_SIZE
    static let kMyViewH:CGFloat = 400*LoanConst.IPHONE6_SIZE
    static let kRedLineDefaultW:CGFloat = 45
    static let kRedLineDefaultH:CGFloat = 1
}

class LoanAddressView: UIView,UIScrollViewDelegate {
    var resultBlock:((selectedAddress:String?)-> Void)?
    var datasArr:[Province]?
    var myView:UIView!
    var selectLabel:UILabel!
    var redLineView:UIView!
    var scrollView:UIScrollView!
    var tableViewArray:[AddressTableView] = []
    var labelArray:[UILabel] = []
    var addressArray:[String] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        let tapView = UIView(frame: CGRect(x: 0, y: 0, width: LoanConst.ScreenW, height: LoanConst.ScreenH-LAddressConst.kMyViewH))
        tapView.userInteractionEnabled = true
        self.addSubview(tapView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.tapClick))
        tapView.addGestureRecognizer(tap)
        //获取数据源
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "plist")
        let dic = NSArray(contentsOfFile: path!)
        datasArr = (Province.mj_objectArrayWithKeyValuesArray(dic).copy() as? Array<Province>)!
        
        myView = UIView(frame: CGRect(x: 0, y: LoanConst.ScreenH, width: LoanConst.ScreenW, height: LAddressConst.kMyViewH))
        myView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(myView!)
        
        addTitleView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Public
    func showView() {
        UIView.animateWithDuration(LAddressConst.kAnimateDuration) {
            self.myView.frame = CGRect(x: 0, y: LoanConst.ScreenH - LAddressConst.kMyViewH, width: LoanConst.ScreenW, height: LAddressConst.kMyViewH)
        }
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
    }
    //MARK: - private
    func addTitleView()  {
        
        //1.0 Title
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: LoanConst.ScreenW, height: LAddressConst.kLabelH))
        titleLable.text = "所在地区"
        titleLable.textColor = UIColor.blackColor()
        titleLable.textAlignment = .Center
        myView?.addSubview(titleLable)
        //2.0 关闭按钮
        let button = UIButton(frame: CGRect(x: LoanConst.ScreenW - LAddressConst.kLabelH, y: 0, width: LAddressConst.kLabelH, height: LAddressConst.kLabelH))
        button.setImage(UIImage(named: "CloseBtn"), forState: .Normal)
        button.addTarget(self, action: #selector(LoanAddressView.tapClick), forControlEvents: .TouchUpInside)
        myView?.addSubview(button)
        //3.0 SelectLable
        selectLabel = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(titleLable.frame), width: LAddressConst.kSelectLabelDefaultW, height: 30*LoanConst.IPHONE6_SIZE))
        selectLabel.textColor = UIColor.redColor()
        selectLabel.textAlignment = .Center
        selectLabel.font = UIFont.systemFontOfSize(LAddressConst.kFontSize)
        selectLabel.userInteractionEnabled = true
        selectLabel.text = LAddressConst.kDefaultContent
        myView?.addSubview(selectLabel!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.selectLabelTapClick))
        selectLabel?.addGestureRecognizer(tap)
        //4.0 LineView 
        let lineView = UIView(frame: CGRect(x: 0, y: CGRectGetMaxY(selectLabel.frame)+0.5, width: LoanConst.ScreenW, height: 0.5))
        lineView.backgroundColor = UIColor.grayColor()
        myView?.addSubview(lineView)
        //5.0 RedLineView
        redLineView = UIView(frame: CGRect(x: CGRectGetMinX(selectLabel.frame)+LAddressConst.kTopLabelMargin, y: CGRectGetMaxY(selectLabel.frame), width: LAddressConst.kRedLineDefaultW, height: LAddressConst.kRedLineDefaultH))
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
        getAddressTableView(0, params: datasArr!)
    }
    
    func getAddressTableView(index:Int , params:[AnyObject]) -> AddressTableView {
        let scrollH = scrollView.frame.size.height
        let tableview = AddressTableView(frame: CGRect(x: LoanConst.ScreenW*CGFloat(index), y: 0, width: LoanConst.ScreenW, height: scrollH), params: params)
        tableview.tag = 1000+index
        tableview.block = {[weak self] (selectedIndex,content,nextArray) in
            //1.0 addressArray处理
            self?.addressArray.removeRange(index..<(self?.addressArray.count ?? index))
            self?.addressArray.append(content)
            //2.0 删除以前的Label新建
            if self?.labelArray.count > index {
                for nextIndex in (index..<(self?.labelArray.count ?? 1)).reverse() {
                    var nextLabel = self?.labelArray[nextIndex]
                    nextLabel?.removeFromSuperview()
                    self?.labelArray.removeAtIndex(nextIndex)
                    nextLabel = nil
                }
            }
            
            let labelWidth = self?.getStringWidth(content) ?? 0
            let fLabel = self?.getLable(index-1)
            //2.1 创建新label
            let currentLabel = nextArray == nil ? nil : self?.getLable(index) //nextArray 是空说明没有下一个了
            currentLabel?.frame = CGRect(x: CGRectGetMaxX((fLabel?.frame ?? CGRectZero)), y: LAddressConst.kLabelH, width: labelWidth+30, height: 30*LoanConst.IPHONE6_SIZE)
            currentLabel?.text = content
            self?.selectLabel.text = nextArray == nil ? content : LAddressConst.kDefaultContent
            self?.selectLabel.textColor = nextArray == nil ? UIColor.blackColor() : UIColor.redColor()
            //3.0 动画
            UIView.animateWithDuration(LAddressConst.kAnimateDuration, animations: {
                if nextArray != nil {
                    self?.selectLabel.frame = CGRect(x: CGRectGetMaxX(currentLabel?.frame ?? CGRectZero), y: LAddressConst.kLabelH, width: LAddressConst.kSelectLabelDefaultW, height: 30*LoanConst.IPHONE6_SIZE)
                    let x = CGRectGetMinX(self?.selectLabel?.frame ?? CGRectZero) + LAddressConst.kTopLabelMargin
                    self?.redLineView.frame = CGRect(x:x , y: CGRectGetMaxY(self?.selectLabel.frame ?? CGRectZero), width: LAddressConst.kRedLineDefaultW, height: LAddressConst.kRedLineDefaultH)
                    currentLabel?.text = content
                }else {
                    self?.selectLabel.frame = CGRect(x: CGRectGetMaxX(fLabel?.frame ?? CGRectZero), y: LAddressConst.kLabelH, width: labelWidth+30, height: 30*LoanConst.IPHONE6_SIZE)
                    let x = CGRectGetMinX(self?.selectLabel?.frame ?? CGRectZero) + LAddressConst.kTopLabelMargin
                    self?.redLineView.frame = CGRect(x:x , y: CGRectGetMaxY(self?.selectLabel.frame ?? CGRectZero), width: labelWidth, height: LAddressConst.kRedLineDefaultH)
                }
            } ,completion: { _ in
//                self?.selectLabel.text = nextArray == nil ? content : "请选择"
            })
            
            //删除以前的TableView新建
            for nextIndex in ((index+1)..<(self?.tableViewArray.count ?? 1)).reverse() {
                var tableView = self?.tableViewArray[nextIndex]
                tableView?.removeFromSuperview()
                self?.tableViewArray.removeAtIndex(nextIndex)
                tableView = nil
            }
           //4.0 设置ScrollView
            if let nArr = nextArray{
                let contentW = CGFloat(index + 2) * LoanConst.ScreenW
                self?.scrollView.contentSize = CGSize(width: contentW, height: scrollH)
                self?.scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW*CGFloat(index+1),y: 0), animated: true)
                //展示新的TableView
                self?.getAddressTableView(index+1, params: nArr)

            }else {
                let contentW = CGFloat(index + 1) * LoanConst.ScreenW
                self?.scrollView.contentSize = CGSize(width: contentW, height: scrollH)
                self?.scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW*CGFloat(index),y: 0), animated: true)
                self?.tapClick()
            }
            
        }
        tableViewArray.append(tableview)
        scrollView.addSubview(tableview)
        return tableview
    }
    //获得指定Index下标的label
    func getLable(index:Int) -> UILabel? {
        if index < 0 {
            return nil
        }
        if labelArray.count > index { //有该label
            return labelArray[index]
        }else {
            let label = UILabel()
            label.font = UIFont.systemFontOfSize(LAddressConst.kFontSize)
            label.textAlignment = .Center
            label.userInteractionEnabled = true
            label.backgroundColor = UIColor.whiteColor()
            label.tag = index
            myView.addSubview(label)
            labelArray.append(label)
            let tap = UITapGestureRecognizer(target: self, action: #selector(LoanAddressView.topLabelClick(_:)))
            label.addGestureRecognizer(tap)
            return label
        }
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/LoanConst.ScreenW
        
        var currentContent:String?
        if addressArray.count > Int(page) {
            currentContent = addressArray[Int(page)]
        }else {
            currentContent = selectLabel.text ?? ""
        }
        //获取当前label
        var currentLabel:UILabel?
        if labelArray.count > Int(page) {
            currentLabel = labelArray[Int(page)]
        }else {
            currentLabel = selectLabel
        }
        let contentW = getStringWidth(currentContent)
        UIView.animateWithDuration(LAddressConst.kAnimateDuration, animations: {
            self.redLineView.frame = CGRect(x: CGRectGetMinX(currentLabel?.frame ?? CGRectZero)+LAddressConst.kTopLabelMargin, y: CGRectGetMaxY(self.selectLabel.frame), width: contentW, height: LAddressConst.kRedLineDefaultH)
        })
    }
    
    //MARK: - Action
    func tapClick()  {
        UIView.animateWithDuration(LAddressConst.kAnimateDuration, animations: {
            self.myView.frame = CGRect(x: 0, y: LoanConst.ScreenH, width: LoanConst.ScreenW, height: LAddressConst.kMyViewH)
        }) { (scucess) in
            self.removeFromSuperview()
        }
        var address:String = ""
        for str in addressArray {
            address = address + "\(str)"
        }
        resultBlock?(selectedAddress: address.characters.count > 0 ? address : nil)
    }
    //点击最后一个label
    func selectLabelTapClick()  {
        let x = CGRectGetMinX(selectLabel?.frame ?? CGRectZero)+LAddressConst.kTopLabelMargin
        let w = getStringWidth(selectLabel.text)
        UIView.animateWithDuration(LAddressConst.kAnimateDuration, animations: {
            self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: LAddressConst.kRedLineDefaultH)
        })
        scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW*CGFloat(tableViewArray.count-1) , y: 0), animated: true)
    }
    //点击前边的label
    func topLabelClick(recognizer:UIGestureRecognizer)  {
        if let label = recognizer.view as? UILabel{
            let tag = label.tag
            let x = CGRectGetMinX(label.frame)+LAddressConst.kTopLabelMargin
            let w = getStringWidth(label.text)
            UIView.animateWithDuration(LAddressConst.kAnimateDuration, animations: {
                self.redLineView.frame = CGRect(x: x, y: CGRectGetMaxY(self.selectLabel.frame), width: w, height: LAddressConst.kRedLineDefaultH)
            })
            scrollView.setContentOffset(CGPoint(x: LoanConst.ScreenW * CGFloat(tag) , y: 0), animated: true)
        }
    }
    //MARK: - 获得label宽度
    func getStringWidth(content:String?) -> CGFloat {
        return content?.getButtonWidth(LAddressConst.kFontSize, height: 30*LoanConst.IPHONE6_SIZE) ?? 0
    }
}
