//
//  GXTSwitch.swift
//  GXTSwitch
//
//  Created by zhuoyue on 2019/9/27.
//  Copyright © 2019 zhuoyue. All rights reserved.
//

import UIKit
typealias  SwitchChange = (_ isOn: Bool) -> Void;
class GXTSwitch: UIControl,UIGestureRecognizerDelegate {
 
    private var imageView:UIImageView!;
    private var potView:UIView!;
    private var touchPoint = CGPoint(x:0,y:0);
    private var canPan = false;
    private var startPoint = CGPoint(x: 0, y: 0);
    private var tapPoint = CGPoint(x: 0, y: 0);
    private var finishChange = false;
    private var isPaning = false;
    var valueChange:SwitchChange?
    var onColor:UIColor?
    var offColor:UIColor?
    var dotDiam = 12.0;
    var isOn = false{
        didSet{
            let size = self.frame.size
            var potFrame = potView.frame
            if potFrame.size.width == 0 && potFrame.size.height == 0{
                let width = self.bounds.size.width
                let height = self.bounds.size.height
                let y = (height-CGFloat(dotDiam))/2
                potFrame = CGRect(x: width-CGFloat(self.dotDiam+(self.dotDiam/2)), y: y, width: CGFloat(self.dotDiam), height: CGFloat(self.dotDiam))
            }
            if isOn{
                let x = size.width-CGFloat(self.dotDiam)-(CGFloat(self.dotDiam)/2)
                potFrame.origin.x = x
                self.layer.borderColor = self.onColor?.cgColor
                potView.backgroundColor = self.onColor
            }else{
                let x = CGFloat(self.dotDiam)/2
                potFrame.origin.x = x
                self.layer.borderColor = self.offColor?.cgColor
                potView.backgroundColor = self.offColor
            }
            potView.frame = potFrame
            
        }
    }
 
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
    }
    func setup()  {
        self.onColor = UIColor.lightGray;
        self.offColor = UIColor.green;
        self.backgroundColor = UIColor.clear;
        
        let panGesture = UIPanGestureRecognizer(target: self
            , action:#selector(panGuesture(gesture:)));
        panGesture.delegate = self ;
        self.addGestureRecognizer(panGesture)
        
        let tapGusture = UITapGestureRecognizer(target: self, action:#selector(tapGesture(gesture:)))
        tapGusture.delegate = self;
        self.addGestureRecognizer(tapGusture)
        
        self.layer.borderWidth = 2.0;
        self.potView = UIView(frame: CGRect.zero);
        self.addSubview(self.potView)
        self.isUserInteractionEnabled = true
        self.isOn = false;
    }
    @objc func panGuesture(gesture:UIPanGestureRecognizer) -> Void {
     let point  = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            isPaning = true
            startPoint = potView.frame.origin
            
            break
        case .ended:
            self.changeStatus(tapPoint: point)
            isPaning = false
            
            break
        case .cancelled:
            self.changeStatus(tapPoint: point)
            isPaning = false
            
            break
        case .changed:
            let size = self.frame.size
            var potFrame = potView.frame
            finishChange = true
            var potX = point.x
            if potX>0{
                potX = point.x+startPoint.x
                let maxX = CGFloat( Double(size.width)-self.dotDiam-(self.dotDiam/2))
                potX = CGFloat( min(maxX, CGFloat(potX)))
            }else{
                potX = point.x+startPoint.x;
                potX = CGFloat( max(potX, CGFloat( self.dotDiam/2)));
            }
            potFrame.origin.x = potX
            potView.frame = potFrame
            isPaning = true
 
            break
        default:
            break
        }
    }
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        tapPoint = point
        if potView.frame.contains(point){
            finishChange = false;
            startPoint = potView.frame.origin
            canPan = true
            isPaning = true
        }
        return true;
 
    }
 
    @objc func tapGesture(gesture:UIPanGestureRecognizer) -> Void {
        let point = gesture.location(in: self)
        self.tapPoint = point
        let y = (self.frame.size.height-CGFloat(self.dotDiam))/2
        let width = self.bounds.size.width
        let tempRect1 = CGRect(x: self.dotDiam/2, y: Double(y), width: self.dotDiam, height: self.dotDiam)
        let rect1 = tempRect1.insetBy(dx:  -(width/4), dy: -(width/4))
        let maxX = Double(width)-self.dotDiam-(self.dotDiam/2)
        let tempRect2 = CGRect(x: maxX, y: Double(y), width: self.dotDiam, height: self.dotDiam)
        let rect2 = tempRect2.insetBy(dx: -(width/4), dy: -(width/4))
        if rect1.contains(tapPoint) || rect2.contains(tapPoint){
            finishChange = true
            self.changeStatus(tapPoint:tapPoint);
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        let height = self.bounds.size.height
        self.layer.cornerRadius = height/2
        potView.layer.cornerRadius = CGFloat(self.dotDiam/2.0);
        self.adjustView();
        
    }
    func adjustView() {
        let size = self.frame.size
        var potFrame = potView.frame
        if self.isOn{
            potFrame.origin.x = size.width-CGFloat(self.dotDiam+(self.dotDiam/2))
            self.layer.borderColor = self.onColor?.cgColor
            potView.backgroundColor = self.onColor
        }else{
            let x = CGFloat(self.dotDiam)/2
            potFrame.origin.x = x
            self.layer.borderColor = self.offColor?.cgColor
            potView.backgroundColor = self.offColor
        }
        potView.frame = potFrame

    }
    func changeStatus(tapPoint:CGPoint) -> Void {
        let size = self.bounds.size
        if tapPoint.x>size.width/2{
            self.isOn = true
        }else{
            self.isOn = false
        }
        if let block = self.valueChange {
            block(self.isOn)
        }
 
    }
  
}
