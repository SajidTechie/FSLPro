//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//
//import UIKit
//import Foundation
//
//public class ViewPagerOptions {
//
//    public enum Distribution {
//
//        /// Tabs are laid out from Left to Right and can be scrolled if the size of all tabs combined exceeds the width of the container view
//        /// Width of each tabs is equal to its content width + paddings set in options.
//        case normal
//
//        /// Tabs are laid out from Left to Right and can be scrolled similar to Normal Distribution. Size of all the tabs are equal.
//        /// Width of each tab is equal to the width of the largest tab. Width of largest tab is determined similar to Normal Distribution.
//        case equal
//
//        /// Tabs are laid out from Left to Right in such a way that it doesnot exceeds the width of its container. So its not scrollable.
//        /// Container is divided into equal parts. Number of parts is determined by the number of tabs. Paddings are ignored.
//        case segmented
//    }
//
//    public var distribution: ViewPagerOptions.Distribution = .normal
//    public var tabType:ViewPagerTabType = .basic
//
//    public var isTabHighlightAvailable:Bool = true
//    public var isTabIndicatorAvailable:Bool = true
//    public var isTabBarShadowAvailable:Bool = true
//
//    public var tabViewBackgroundDefaultColor:UIColor = Color.tabViewBackground
//    public var tabViewBackgroundHighlightColor:UIColor = Color.tabViewHighlight
//
//    public var tabViewTextDefaultColor:UIColor = Color.textDefault
//    public var tabViewTextHighlightColor:UIColor = Color.textHighlight
//
//    public var tabViewHeight:CGFloat = 60
//    public var tabViewPaddingLeft:CGFloat = 10.0
//    public var tabViewPaddingRight:CGFloat = 10.0
//    public var tabViewTextFont:UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
//
//    public var tabViewImageSize:CGSize = CGSize(width: 20, height: 20)
//    public var tabViewImageMarginTop:CGFloat = 10
//    public var tabViewImageMarginBottom:CGFloat = 5
//
//    public var shadowColor: UIColor = UIColor.black
//    public var shadowOpacity: Float = 0.3
//    public var shadowOffset: CGSize = CGSize(width: 0, height: 3)
//    public var shadowRadius: CGFloat = 3
//
//    // Tab Indicator
//    public var tabIndicatorViewHeight:CGFloat = 3
//    public var tabIndicatorViewBackgroundColor:UIColor = Color.tabIndicator
//
//    // ViewPager
//    public var viewPagerTransitionStyle:UIPageViewController.TransitionStyle = .scroll
//
//    public init() {
//        // Initialization
//    }
//
//    fileprivate struct Color {
//
//        static let tabViewBackground = UIColor(red: 23 / 255.0, green: 26/255.0, blue: 33/255.0, alpha: 1.0)
//        static let tabViewHighlight = tabViewBackground.withAlphaComponent(0.8)
//
//        static let textDefault = UIColor.white
//        static let textHighlight = UIColor.white
//
//        static let tabIndicator =  UIColor(red: 214 / 255.0, green: 73/255.0, blue: 51/255.0, alpha: 1.0)
//    }
//}
import UIKit
import Foundation

public class ViewPagerOptions {

    public var viewPagerFrame:CGRect = CGRect.zero

    // Tabs Customization
    public var tabType : ViewPagerTabType = .basic
    public var isTabHighlightAvailable:Bool = false
    public var isTabIndicatorAvailable:Bool = true
    public var tabViewBackgroundDefaultColor:UIColor = Color.tabViewBackground
    public var tabViewBackgroundHighlightColor:UIColor = Color.tabViewHighlight
    public var tabViewTextDefaultColor:UIColor = Color.textDefault
    public var tabViewTextHighlightColor:UIColor = Color.textHighlight

    // Booleans

    /// Width of each tab is equal to the width of the largest tab. Tabs are laid out from Left - Right and are scrollable
    public var isEachTabEvenlyDistributed:Bool = false
    /// All the tabs are squeezed to fit inside the screen width. Tabs are not scrollable. Also it overrides isEachTabEvenlyDistributed
    public var fitAllTabsInView:Bool = false

    // Tab Properties
    public var tabViewHeight:CGFloat = 50.0
    public var tabViewPaddingLeft:CGFloat = 10.0
    public var tabViewPaddingRight:CGFloat = 10.0
    public var tabViewTextFont:UIFont = UIFont.systemFont(ofSize: 16)
    public var tabViewImageSize:CGSize = CGSize(width: 25, height: 25)
    public var tabViewImageMarginTop:CGFloat = 5
    public var tabViewImageMarginBottom:CGFloat = 5

    // Tab Indicator
    public var tabIndicatorViewHeight:CGFloat = 3
    public var tabIndicatorViewBackgroundColor:UIColor = Color.tabIndicator

    // ViewPager
    public var viewPagerTransitionStyle:UIPageViewController.TransitionStyle = .scroll

    /**
     * Initializes Options for ViewPager. The frame of the supplied UIView in view parameter is
     * used as reference for ViewPager width and height.
     */
    public init(viewPagerWithFrame frame:CGRect) {
        self.viewPagerFrame = frame
    }

    fileprivate struct Color {

        
        static let topBackground = UIColor.from(r: 71, g: 85, b: 134)
        static let botomBackground = UIColor.from(r: 12, g: 17, b: 59)
        
        static let tabViewBackground = UIColor.from(r: 230.0, g: 230, b: 220)
        static let tabViewHighlight = UIColor.from(r: 129, g: 165, b: 148)
        static let textDefault = UIColor.black
        static let textHighlight = UIColor.white
        static let tabIndicator = UIColor.from(r: 255, g: 102, b: 0)
    }
}

fileprivate extension UIColor {

    class func from(r: CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    
    
}
