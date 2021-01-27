//
//  WKWebView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 27/1/2564 BE.
//

import Foundation
import WebKit

typealias OlderClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any?) -> Void
typealias NewerClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void

extension WKWebView{

    var keyboardDisplayRequiresUserAction: Bool? {
        get {
            return self.keyboardDisplayRequiresUserAction
        }
        set {
            self.setKeyboardRequiresUserInteraction(newValue ?? true)
        }
    }

    func setKeyboardRequiresUserInteraction( _ value: Bool) {

        guard
            let WKContentViewClass: AnyClass = NSClassFromString("WKContentView") else {
                print("Cannot find the WKContentView class")
                return
        }

        let olderSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        let newerSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")

        if let method = class_getInstanceMethod(WKContentViewClass, olderSelector) {

            let originalImp: IMP = method_getImplementation(method)
            let original: OlderClosureType = unsafeBitCast(originalImp, to: OlderClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3) in
                original(me, olderSelector, arg0, !value, arg2, arg3)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

        if let method = class_getInstanceMethod(WKContentViewClass, newerSelector) {

            let originalImp: IMP = method_getImplementation(method)
            let original: NewerClosureType = unsafeBitCast(originalImp, to: NewerClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                original(me, newerSelector, arg0, !value, arg2, arg3, arg4)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

    }

}
