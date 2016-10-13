//
//  UIExtensions+UILable.swift
//  ActionMenu
//
//  Created by 樊半缠 on 16/8/11.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class ActionLabel: UILabel {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    //  MARK: life cycle
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure() -> Void {
        self.isUserInteractionEnabled = true
        
        //当前控件是label 所以是给label添加敲击手势
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.Tap))
        
        self.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func Tap() -> Void {
        self.becomeFirstResponder()
        let actions: [UIMenuItem] = [UIMenuItem.init(title: "Copy", action: #selector(self.copyText)),
                                     UIMenuItem.init(title: "Paste", action: #selector(self.pasteText)),
                                     UIMenuItem.init(title: "Cut", action: #selector(self.cutText)),
                                     UIMenuItem.init(title: "Red", action: #selector(self.red)),
                                     UIMenuItem.init(title: "Blue", action: #selector(self.blue)),
                                     UIMenuItem.init(title: "Green", action: #selector(self.green))]
        
        let menu = ActionMenu.init(actions: actions, direction: nil, inView: self)
        
        menu.show(animated: true) { () in
            
            let thud = #selector(ActionMenuDelegate.actionMenuDidDismissed(_:))
            
            if menu.delegate != nil{
                let xyzzy: Bool = menu.delegate!.responds(to: thud)
                if xyzzy {  menu.delegate?.actionMenuDidDismissed(menu)     }
            }
        }
    }
}
extension ActionLabel: ActionableProtocol{
    open override var canBecomeFirstResponder : Bool {
        return true
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        (foo,bar, baz, qux, quux, corge,grault, garply, waldo, fred, plugh, xyzzy, thud)
        let foo = (action == #selector(self.copyText)) && (self.text?.characters.count > 0)// 需要有文字才能支持复制
        let bar = action == #selector(self.pasteText)
        let baz = (action == #selector(self.cutText)) && (self.text?.characters.count > 0)// 需要有文字才能支持剪切
        let qux = action == #selector(self.red)
        let corge = action == #selector(self.blue)
        let grault = action == #selector(self.green)
        
        let waldo: Bool = foo || bar || baz || qux || corge || grault
        
        if waldo{
            return true
        }
        
        return false
    }
    
    
}
//  MARK: support actions
extension ActionLabel {
    /** 剪切 */
    func cutText() -> Void {
        //UIPasteboard 是可以在应用程序与应用程序之间共享的
        // 将label的文字存储到粘贴板
        UIPasteboard.general.string = self.text
        // 清空文字
        self.text = nil;
    }
    /** 复制 */
    func copyText() -> Void {
        // 将label的文字存储到粘贴板
        UIPasteboard.general.string = self.text
    }
    /** 粘贴 */
    func pasteText() -> Void {
        // 将粘贴板的文字赋值给label
        self.text = UIPasteboard.general.string
    }
    //如果方法不实现,是不会显示出来的
    func red() -> Void {
        self.textColor = UIColor.red
    }
    func blue() -> Void {
        self.textColor = UIColor.blue
    }
    func green() -> Void {
        self.textColor = UIColor.green
    }
}
