//
//  HostedView.swift
//
//  Created by Rodrigo Galvez on 18/05/23.
//

import SwiftUI

public protocol HostedView: View {}

public extension HostedView {
    var hostingControllerView: UIView { convert(view: self) }
    func convert<Content: View>(view: Content) -> UIView {
        return UIHostingController(rootView: view, ignoreSafeArea: true, ignoresKeyboard: true).view
    }
    func getController() -> UIHostingController<Self> {
        return UIHostingController(rootView: self, ignoreSafeArea: true, ignoresKeyboard: true)
    }
    func getViewAndAddControllerAsChild(of vc: UIViewController) -> UIView {
        let controller = getController()
        vc.addChild(controller)
        return controller.view
    }
}

//This fixes issue where the safe area was being applied to cells when they were reused
//https://defagos.github.io/swiftui_collection_part3/

//This fixes a layoutSubviews cycle when showing the keyboard, and also fixes the views moving when the keyboard is shown
//https://steipete.com/posts/disabling-keyboard-avoidance-in-swiftui-uihostingcontroller/
extension UIHostingController {
    convenience public init(rootView: Content, ignoreSafeArea: Bool, ignoresKeyboard: Bool) {
        self.init(rootView: rootView)
        
        if ignoreSafeArea {
            disableSafeArea()
        }
        if ignoresKeyboard {
            ignoredKeyboard()
        }
    }
    
    func disableSafeArea() {
        guard let viewClass = object_getClass(view) else { return }
        
        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
            
            if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
                    return .zero
                }
                class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
            }
            
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
    
    func ignoredKeyboard() {
        guard let viewClass = object_getClass(view) else { return }

        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

            if let method = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
                let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
                class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"),
                                imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method))
            }
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
}
