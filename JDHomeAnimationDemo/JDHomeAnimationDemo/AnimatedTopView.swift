//
//  AnimatedTopView.swift
//  WebViewTest
//
//  Created by zhangzb on 2019/8/17.
//  Copyright © 2019 zhangzb. All rights reserved.
//

import UIKit

class AnimatedTopView: UIView {
    var titleLabel = UILabel(frame: .zero)
    var firstBtn = UIButton(frame: .zero)
    var secondBtn = UIButton(frame: .zero)
    var searchBar = UISearchBar(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 108)
        self.setupUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIElements() {
        self.titleLabel.frame = CGRect(x: 12, y: 32, width: 180, height: 20)
        self.titleLabel.textColor = .white
        self.titleLabel.text = "这里是标题"
        self.addSubview(self.titleLabel)
        
        self.firstBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 108 + 16, y: 27, width: 30, height: 30)
        self.firstBtn.setImage(UIImage(named: "icon_buy"), for: .normal)
        self.addSubview(self.firstBtn)
        
        self.secondBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 16 - 30, y: 27, width: 30, height: 30)
        self.secondBtn.setImage(UIImage(named: "icon_chart"), for: .normal)
        self.addSubview(self.secondBtn)
        
        self.searchBar.frame.origin.y = 64
        self.searchBar.searchBarStyle = .minimal
        self.addSubview(self.searchBar)
        if let textFieldBgImageView = self.searchBar.subviews.first?.subviews.last?.subviews.first {
            textFieldBgImageView.backgroundColor = .white
            textFieldBgImageView.layer.cornerRadius = 18
        }
    }
    
    override func layoutSubviews() {
        self.titleLabel.frame = CGRect(x: 12, y: 32, width: UIScreen.main.bounds.size.width - 108, height: 20)
        self.firstBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 108 + 16, y: 27, width: 30, height: 30)
        self.secondBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 16 - 30, y: 27, width: 30, height: 30)
        
        let dy = self.frame.size.height - 108
        if (dy < 0) {
            let ratio = dy/20
            self.searchBar.frame = CGRect(x: 0, y: 64 + dy, width: ratio >= -1 ? UIScreen.main.bounds.size.width+108*ratio : UIScreen.main.bounds.size.width-108, height: 44)
            self.titleLabel.alpha = (1 + ratio)
        } else {
            self.searchBar.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 44)
            self.titleLabel.alpha = 1
        }
    }
}
