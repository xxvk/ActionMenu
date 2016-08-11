//
//  ActionMenu.swift
//  Demo
//
//  Created by 樊半缠 on 16/8/9.
//  Copyright © 2016年 reformation.tech All rights reserved.
//

import UIKit

@objc public protocol ActionMenuDelegate: NSObjectProtocol {
    func actionMenuDidDismissed(menu: ActionMenu)
    
}
public class ActionMenu: NSObject {
    
    public let raw: UIMenuController = UIMenuController.sharedMenuController()
    
    //  MARK: interactive
    public weak var delegate: ActionMenuDelegate?
    
    public var targetRect: CGRect?
    public var inView: UIView?
    
    override public init() {
        super.init()
    }
    
    convenience public init(actions:[UIMenuItem], direction: UIMenuControllerArrowDirection?, inView: UIView)
    {
        self.init()
        
        if direction != nil {
            self.raw.arrowDirection = direction!
        }else{
            self.raw.arrowDirection = .Default
        }
        
        if !(inView.isFirstResponder()) {
            inView.becomeFirstResponder()
        }
        
        self.raw.menuItems = actions
        
        
        self.targetRect = CGRectMake(0,
                                     inView.bounds.height * 0.5,
                                     inView.bounds.width,
                                     1)
        self.inView = inView
        /*
         targetRect：menuController指向的矩形框
         targetView：targetRect以targetView的左上角为坐标原点
         */
        dispatch_async(dispatch_get_main_queue()) {
            self.raw.setTargetRect(self.targetRect! , inView: self.inView!)
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
    public func show(animated animated: Bool, handler completion: (Void) -> Void) -> Void {
        self.raw.setTargetRect(self.targetRect! , inView: self.inView!)
        
        self.raw.update()
        
        self.raw.setMenuVisible(true, animated: animated)
        
        completion()
    }
    
    public func dismiss(animated animated: Bool, handler completion: (Void) -> Void) -> Void {
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
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool
    
    func canBecomeFirstResponder() -> Bool
}
//  MARK: Sample of protocol overrides :
extension ActionableProtocol {
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool{
        let raw = UIMenuController.sharedMenuController()
        for item in raw.menuItems! {
            if action.description == item.action.description{
                return true
            }
        }
        return false
    }
    
    func canBecomeFirstResponder() -> Bool{
        return true
    }
}
