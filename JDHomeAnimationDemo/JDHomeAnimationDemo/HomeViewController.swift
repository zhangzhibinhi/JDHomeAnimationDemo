//
//  HomeViewController.swift
//  WebViewTest
//
//  Created by zhangzb on 2019/8/17.
//  Copyright © 2019 zhangzb. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //颜色数组（这里使用三组颜色作为渐变）fc6820
        let compoents:[CGFloat] = [0xfc/255, 0x68/255, 0x20/255, 1,
                                   0xfe/255, 0xd3/255, 0x2f/255, 1,
                                   0xb1/255, 0xfc/255, 0x33/255, 1]
        //没组颜色所在位置（范围0~1)
        let locations:[CGFloat] = [0,0.5,1]
        //生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        
        //渐变开始位置
        let start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        //渐变结束位置
        let end = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        //绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end,
                                   options: .drawsBeforeStartLocation)
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: GradientView!
    var animatedTopView: AnimatedTopView = AnimatedTopView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTopView()
    }
    
    func setupTopView() {
        self.animatedTopView.frame.origin.x = self.view.safeAreaInsets.top
        self.animatedTopView.backgroundColor = UIColor.red
        self.view.addSubview(self.animatedTopView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = CGRect(x: 0, y: self.animatedTopView.bounds.maxY, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-self.animatedTopView.bounds.maxY)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.animatedTopView.frame.size.height = scrollView.contentOffset.y <= 44 ? (108 - scrollView.contentOffset.y) : 64
        self.view.setNeedsLayout()
    }
}
