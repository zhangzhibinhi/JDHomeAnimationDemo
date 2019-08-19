# JDHomeAnimationDemo
仿京东首页顶部搜索栏动画实现

###动画效果分析
1. 导航栏：根据滑动距离改变导航栏高度
- 向上滑动时：导航栏高度减少（最小为44+safeAreaInset.top）
- 向下滑动时：导航栏高度增加（最大为88+safeAreaInset.top）
2. 标题栏：根据导航栏高度改变标题栏的不透明度，临界点为标题栏与SearchBar接触时
- 向上滑动时：不透明度降低，直到临界点变为0后不再降低
- 向下滑动时：未到临界点前不透明度不变，直到临界点后开始增加直到变为1
3. SearchBar：根据导航栏高度改变searchBar的y和高度，临界点为标题栏与SearchBar接触时
SearchBar y值跟随导航栏高度增加或减少
- 向上滑动时：SearchBar宽度减少，直到临界点变为合适宽度后不再减少
- 向下滑动时：未到临界点前宽度不变，直到临界点后宽度开始增加直到变为最大44

###动画效果实现
1. 导航栏
由于导航栏比较复杂，且需要根据滑动来动态改变高度，所以采用了自定义view来实现
```
// 配置页面
func setupUIElements() {
    self.titleLabel.textColor = .white
    self.titleLabel.text = "这里是标题"
    self.addSubview(self.titleLabel)

    self.firstBtn.setImage(UIImage(named: "icon_buy"), for: .normal)
    self.addSubview(self.firstBtn)

    self.secondBtn.setImage(UIImage(named: "icon_chart"), for: .normal)
    self.addSubview(self.secondBtn)

    self.searchBar.searchBarStyle = .minimal
    self.addSubview(self.searchBar)
    if let textFieldBgImageView = self.searchBar.subviews.first?.subviews.last?.subviews.first {
        textFieldBgImageView.backgroundColor = .white
        textFieldBgImageView.layer.cornerRadius = 18
    }
}

override func layoutSubviews() {
    self.titleLabel.frame = CGRect(x: 12, y: 12 + self.safeAreaInsets.top , width: UIScreen.main.bounds.size.width - 108, height: 20)
    self.firstBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 108 + 16, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
    self.secondBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 16 - 30, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
}
```
在scrollView的delegate里改变topView的高度
```
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.scrollView.frame = CGRect(x: 0, y: self.animatedTopView.bounds.maxY, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-self.animatedTopView.bounds.maxY)
}

func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.animatedTopView.frame.size.height = (scrollView.contentOffset.y <= 44 ? (88 + self.view.safeAreaInsets.top - scrollView.contentOffset.y) : (44 + self.view.safeAreaInsets.top))
    self.view.setNeedsLayout()
}
```

2. 标题栏
根据topView的高度来改变标题栏的alpha
```
override func layoutSubviews() {
    self.titleLabel.frame = CGRect(x: 12, y: 12 + self.safeAreaInsets.top , width: UIScreen.main.bounds.size.width - 108, height: 20)
    self.firstBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 108 + 16, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
    self.secondBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 16 - 30, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
    let dy = self.frame.size.height - self.initialHeight
    if (dy < 0) {
        let ratio = dy/20
        self.titleLabel.alpha = (1 + ratio)
    } else {
        self.titleLabel.alpha = 1
    }
}
```

3. SearchBar
SearchBar y值跟随导航栏高度增加或减少
- 向上滑动时：SearchBar宽度减少，直到临界点变为合适宽度后不再减少
- 向下滑动时：未到临界点前宽度不变，直到临界点后宽度开始增加直到变为最大44
```
override func layoutSubviews() {
    self.titleLabel.frame = CGRect(x: 12, y: 12 + self.safeAreaInsets.top , width: UIScreen.main.bounds.size.width - 108, height: 20)
    self.firstBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 108 + 16, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
    self.secondBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 16 - 30, y: 7 + self.safeAreaInsets.top, width: 30, height: 30)
    let dy = self.frame.size.height - self.initialHeight
    if (dy < 0) {
        let ratio = dy/20
        self.searchBar.frame = CGRect(x: 0, y: 44 + self.safeAreaInsets.top + dy, width: ratio >= -1 ? UIScreen.main.bounds.size.width+108*ratio : UIScreen.main.bounds.size.width-108, height: 44)
        self.titleLabel.alpha = (1 + ratio)
    } else {
        self.initialHeight = 88 + self.safeAreaInsets.top
        self.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: self.initialHeight)
        self.searchBar.frame = CGRect(x: 0, y: 44 + self.safeAreaInsets.top, width: UIScreen.main.bounds.size.width, height: 44)
        self.titleLabel.alpha = 1
    }
}
```
