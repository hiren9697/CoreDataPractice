//
//  Constants.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 11/01/25.
//

import UIKit

struct App {
    static let application    = UIApplication.shared
    static let appDelegator   = UIApplication.shared.delegate! as! AppDelegate
    static let defaultCenter  = NotificationCenter.default
    static let userDefault    = UserDefaults.standard
    //static var user: User?
}

struct Geometry {
    static let screenFrame     : CGRect     = UIScreen.main.bounds
    static let screenSize      : CGSize     = UIScreen.main.bounds.size
    static let screenWidth     : CGFloat    = screenSize.width
    static let screenHeight    : CGFloat    = screenSize.height
    static let windowScene     : UIWindowScene?   = App.application.connectedScenes.first as? UIWindowScene
    static let window          : UIWindow?  = windowScene?.windows.last
    static let topSafearea     : CGFloat    = window?.safeAreaInsets.top ?? 0
    static let bottomSafearea  : CGFloat    = window?.safeAreaInsets.bottom ?? 0
    static let statusbarHeight : CGFloat    = topSafearea
    static let navigationHeight: CGFloat    = 44 + topSafearea
    static let widthRation     : CGFloat    = screenWidth / 414
    static let heightRation    : CGFloat    = screenHeight / 896
    static let hasNotch        : Bool       = App.appDelegator.window!.safeAreaInsets.bottom > 0
    static let minImageSize    : CGSize     = CGSize(width: 300, height: 300)
}
