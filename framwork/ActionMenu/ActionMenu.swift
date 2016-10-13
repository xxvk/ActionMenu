//
//  ActionMenu.swift
//  Demo
//
//  Created by 樊半缠 on 16/8/9.
//  Copyright © 2016年 reformation.tech All rights reserved.
//

import UIKit

@objc public protocol ActionMenuDelegate: NSObjectProtocol {
    func actionMenuDidDismissed(_ menu: ActionMenu)
    
}
open class ActionMenu: NSObject {
    
    open let raw: UIMenuController = UIMenuController.shared
    
    //  MARK: interactive
    open weak var delegate: ActionMenuDelegate?
    
    open var targetRect: CGRect?
    open var inView: UIView?
    
    override public init() {
        super.init()
    }
    
    convenience public init(actions:[UIMenuItem], direction: UIMenuControllerArrowDirection?, inView: UIView)
    {
        self.init()
        
        if direction != nil {
            self.raw.arrowDirection = direction!
        }else{
            self.raw.arrowDirection = .default
        }
        
        if !(inView.isFirstResponder) {
            inView.becomeFirstResponder()
        }
        
        self.raw.menuItems = actions
        
        
        self.targetRect = CGRect(x: 0,
                                     y: inView.bounds.height * 0.5,
                                     width: inView.bounds.width,
                                     height: 1)
        self.inView = inView
        /*
         targetRect：menuController指向的矩形框
         targetView：targetRect以targetView的左上角为坐标原点
         */
        DispatchQueue.main.async {
            self.raw.setTargetRect(self.targetRect! , in: self.inView!)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        self.delegate = nil
        
        self.inView = nil
        self.targetRect = nil
    }
}
//  MARK: UI action
extension ActionMenu{
    public func show(animated: Bool, handler completion: (Void) -> Void) -> Void {
        self.raw.setTargetRect(self.targetRect! , in: self.inView!)
        
        self.raw.update()
        
        self.raw.setMenuVisible(true, animated: animated)
        
        completion()
    }
    
    public func dismiss(animated: Bool, handler completion: (Void) -> Void) -> Void {
        self.raw.update()
        
        self.raw.setMenuVisible(false, animated: animated)
        
        completion()
    }
}
/*
 override those functions in UIView or Controller need to be
 */
//  MARK: - ActionableProtocol
@objc public protocol ActionableProtocol {
    @objc optional func canPerformAction(_ action: Selector, withSender sender: AnyObject?) -> Bool
    
    @objc optional func canBecomeFirstResponder() -> Bool
}
//  MARK: Sample of protocol overrides :
extension ActionableProtocol {
    public func canPerformAction(_ action: Selector, withSender sender: AnyObject?) -> Bool{
        let raw = UIMenuController.shared
        for item in raw.menuItems! {
            if action.description == item.action.description{
                return true
            }
        }
        return false
    }
    
    public func canBecomeFirstResponder() -> Bool{
        return true
    }
}
