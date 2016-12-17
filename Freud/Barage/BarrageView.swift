//
//  BarrageView.swift
//  ClassE
//
//  Created by JinHongxu on 2016/12/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//


import UIKit
import SocketIO
import SnapKit

enum BarrageViewStyle {
    case white
    case black
}

class BarrageView: UIView, SocketManagerDelegate, CAAnimationDelegate {
    
    let statusLabel = UILabel()
    let reconnectButton = UIButton()
    
    convenience init(style: BarrageViewStyle = .white) {
        self.init()
        SocketManager.shared.delegate = self
        
        self.addSubview(statusLabel)
        self.addSubview(reconnectButton)
        
        statusLabel.text = "正在连接弹幕服务器..."
        switch style {
        case .black:
            statusLabel.textColor = UIColor.black
        case .white:
            statusLabel.textColor = UIColor.white
        }
        
        statusLabel.snp.makeConstraints {
            make in
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(8)
            make.width.equalTo(200)
            make.height.equalTo(16)
        }
        
        switch style {
        case .black:
            reconnectButton.setImage(UIImage(named: "ic_refresh") , for: .normal)
        case .white:
            reconnectButton.setImage(UIImage(named: "ic_refresh_white") , for: .normal)
        }
        reconnectButton.addTarget(self, action: #selector(connectSocket), for: .touchUpInside)
        reconnectButton.snp.makeConstraints{
            make in
            make.top.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
    }
    
    func connectSocket() {
        self.statusLabel.text = "正在连接弹幕服务器..."
        self.statusLabel.alpha = 1
        SocketManager.shared.reconnect()
    }
    
    func SocketDidConnect() {
        print("socket connected")
        self.statusLabel.text = "弹幕服务器连接成功"
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveLinear, animations: {
            self.statusLabel.alpha = 0
        }, completion: nil)
    }
    
    func SocketDidReciveMessage(message: String) {
        let label: UILabel = UILabel(frame: CGRect(x: 375, y: Int(arc4random()%530)/25*25, width: 100, height: 25))
        if message == "like" {
            likeAnimation()
        } else {
            label.text = message
            label.textColor = UIColor.white
            label.shadowColor = UIColor.black
            label.shadowOffset = CGSize(width: 1, height: 1)
            label.sizeToFit()
            self.addSubview(label)
            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
                label.frame.origin.x -= label.frame.size.width+375
            }, completion: { flag in
                label.removeFromSuperview()
            })
        }
    }
    
    //飘心动画
    func likeAnimation() {
        var tagNumber: Int = 500000
        tagNumber+=1
        
        let image = UIImage.init(named: randomImageName())
        let imageView = UIImageView.init(image: image)
        imageView.center = CGPoint(x: -5000, y :-5000)
        imageView.tag = tagNumber
        self.addSubview(imageView)
        
        let group = groupAnimation()
        group.setValue(tagNumber, forKey: "animationName")
        imageView.layer.add(group, forKey: "wendingding")
    }
    
    func groupAnimation() -> CAAnimationGroup{
        
        let group = CAAnimationGroup.init()
        group.duration = 2.0;
        group.repeatCount = 1;
        let animation = scaleAnimation()
        let keyAnima = positionAnimatin()
        let alphaAnimation = alphaAnimatin()
        group.animations = [animation, keyAnima, alphaAnimation]
        group.delegate = self;
        return group
    }
    
    func scaleAnimation() -> CABasicAnimation {
        // 设定为缩放
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 0.5// 动画持续时间
        //    animation.autoreverses = NO; // 动画结束时执行逆动画
        animation.isRemovedOnCompletion = false
        
        // 缩放倍数
        animation.fromValue = 0.1 // 开始时的倍率
        animation.toValue = 1.0 // 结束时的倍率
        return animation
    }
    
    func positionAnimatin() -> CAKeyframeAnimation {
        
        let keyAnima=CAKeyframeAnimation.init()
        keyAnima.keyPath="position"
        
        //1.1告诉系统要执行什么动画
        //创建一条路径
        let path = CGMutablePath()
        
        //设置一个圆的路径
        //    CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 100, 100, 100));
        
        path.move(to: CGPoint(x: 333, y: 560))
        let controlX = Int((arc4random() % (100 + 1))) - 50
        let controlY = Int((arc4random() % (130 + 1))) + 50
        let entX = Int((arc4random() % (100 + 1))) - 50
        
        //CGPathAddQuadCurveToPoint(path, nil, CGFloat(200 - controlX), CGFloat(200 - controlY), CGFloat(200 + entX), 200 - 260)
        path.addQuadCurve(to: CGPoint(x: CGFloat(333 - controlX), y: CGFloat(200 - controlY)), control: CGPoint(x: CGFloat(200 + entX), y:200 - 260))
        
        keyAnima.path=path;
        //有create就一定要有release, ARC自动管理
        //        CGPathRelease(path);
        //1.2设置动画执行完毕后，不删除动画
        keyAnima.isRemovedOnCompletion = false
        //1.3设置保存动画的最新状态
        keyAnima.fillMode=kCAFillModeForwards
        //1.4设置动画执行的时间
        keyAnima.duration=2.0
        //1.5设置动画的节奏
        keyAnima.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        return keyAnima
    }
    
    func alphaAnimatin() -> CABasicAnimation {
        
        let alphaAnimation = CABasicAnimation.init(keyPath: "opacity")
        
        // 动画选项设定
        alphaAnimation.duration = 1.5 // 动画持续时间
        alphaAnimation.isRemovedOnCompletion = false
        
        alphaAnimation.fromValue = 1.0
        alphaAnimation.toValue = 0.1
        alphaAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        alphaAnimation.beginTime = 0.5
        
        return alphaAnimation
    }
    func randomImageName() -> String {
        
        let number = Int(arc4random() % (4 + 1));
        var randomImageName: String
        switch (number) {
        case 1:
            randomImageName = "bHeart"
            break;
        case 2:
            randomImageName = "gHeart"
            break;
        case 3:
            randomImageName = "rHeart"
            break;
        case 4:
            randomImageName = "yHeart"
            break;
        default:
            randomImageName = "bHeart"
            break;
        }
        return randomImageName
    }
}
