//
//  SegmentedControl6.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 15/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

protocol SegmentedControl6Delegate {
    func changedIndex(selectedIndex index:Int)
}

@IBDesignable class SegmentedControl6: UIControl{
    
    var selectedIndex :Int?
    var delegate: SegmentedControl6Delegate? = nil
    
    fileprivate var labels = [UILabel]()
    fileprivate let thumbView = UIView()
    fileprivate var labelStrings = ["1D","1M","3M","6M","1Y","5Y"]
    fileprivate var xSkip = 0
    fileprivate var color = UIColor(red: 26.0/255.0, green: 128.0/255.0, blue: 168.0/255.0, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAndLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewAndLabels()
    }
    
    
    
    fileprivate func setupViewAndLabels(){
        
        
        //setting up view
        self.backgroundColor = .clear
        self.layer.borderColor = self.color.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5.0
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: UIScreen.main.bounds.width - (self.frame.origin.x * 2), height: self.frame.height)
        
        
        
        
        var i = 0
        xSkip = Int(self.frame.size.width) / self.labelStrings.count
        
        
        //setting up labels
        for labelText in labelStrings{
            
            let label = UILabel(frame: CGRect(x: xSkip * i, y: 0, width: xSkip, height: Int(self.frame.height)))
            label.font = UIFont.systemFont(ofSize: 13.0)
            label.textAlignment = .center
            if i == 0{
                self.thumbView.frame = label.frame
                self.thumbView.backgroundColor = self.color
                self.thumbView.layer.cornerRadius = 5.0
                self.addSubview(thumbView)
                label.textColor = .white
            } else {
                label.textColor = self.color
            }
            label.text = labelText
            
            self.addSubview(label)
            labels.append(label)
            i+=1
            
        }
    }
    

    
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
                let touchL = touch.location(in: self)
        for i in 0..<labels.count{
            labels[i].textColor = self.color
            if labels[i].frame.contains(touchL){
                self.selectedIndex = i
                if delegate != nil{
                    delegate!.changedIndex(selectedIndex: self.selectedIndex!)
                }
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .allowAnimatedContent, animations: {
                    self.labels[i].textColor = .white
                    self.thumbView.frame = CGRect(x: CGFloat(i * self.xSkip), y: 0, width: self.frame.width / CGFloat(self.labels.count), height: self.frame.height)
                    
                }, completion: nil)
                
            }
            
        }
        return false
    }
    
    
    
}

