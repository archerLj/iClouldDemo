//
//  LFAlert.swift
//  SwiftLearn
//
//  Created by archerLj on 16/3/29.
//  Copyright © 2016年 archerLj. All rights reserved.
//

import Foundation
import UIKit

class LFAlert {
    
    // 只带一个取消按钮的alert
    class func alert(title title: String, message: String?, cancelButtonTitle cancleTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction:(() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let action: UIAlertAction = UIAlertAction(title: cancleTitle, style: .Default, handler: { action in
                if let dismissAction = dismissAction {
                    dismissAction()
                }
            })
            alertController.addAction(action)
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // 带提交和放弃按钮的alert
    class func cancelOrConfirm(title title:String, message: String, confirmButtonTitle confirmTitle: String, cancelButtonTitle cancelTitle: String, inViewController viewController: UIViewController?,  withConfirmAction confirmAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) { 
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .Default, handler: { action  in
                if let cancelAction = cancelAction {
                    cancelAction()
                }
            })
            alertController.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: confirmTitle, style: .Default, handler: { action in
                if let confirmAction = confirmAction {
                    confirmAction()
                }
            })
            alertController.addAction(confirmAction)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // 带一个输入框和一个按钮的alert
    class func textInput(title title: String, initialText text: String, placeHolder: String, finishButtonTitle finishTitle: String, inViewController viewController: UIViewController?, withFinishAction finishAction: ((text: String) -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) { 
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler({ (textField) in
                textField.placeholder = placeHolder
                textField.text = text
            })
            
            let action = UIAlertAction(title: finishTitle, style: .Default, handler: { (action) in
                if let finishAction = finishAction {
                    if let textField = alertController.textFields?.first, text = textField.text {
                        finishAction(text: text)
                    }
                }
            })
            alertController.addAction(action)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // 带一个输入框和两个按钮的alert
    class func textInput(title title: String, message: String, initialText text: String, placeHolder: String, cancelButtonTitle cancelTitle: String, confirmButtonTitle confirmTitle: String, inViewController viewController: UIViewController?, withConfirmAction confirmAction:((text: String) -> Void)?, cancelAction: (() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) { 
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler({ (textField) in
                textField.placeholder = placeHolder
                textField.text = text
            })
            
            let _cancelAction = UIAlertAction(title: cancelTitle, style: .Default, handler: { (action) in
                if let cancelAction = cancelAction {
                    cancelAction()
                }
            })
            alertController.addAction(_cancelAction)
            
            let _confirmAction = UIAlertAction(title: confirmTitle, style: .Default , handler: { (action) in
                if let confirmAction = confirmAction {
                    if let textField = alertController.textFields?.first, text = textField.text {
                        confirmAction(text: text)
                    }
                }
            })
            alertController.addAction(_confirmAction)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}