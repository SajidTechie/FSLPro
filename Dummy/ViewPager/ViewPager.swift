//
//  ViewPagerController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//


import Foundation
import UIKit

public protocol ViewPagerDataSource: AnyObject {
    
    /// Number of pages to be displayed
    func numberOfPages() -> Int
    
    /// ViewController for required page position
    func viewControllerAtPosition(position:Int) -> UIViewController
    
    /// Tab structure of the pages
    func tabsForPages() -> [ViewPagerTab]
    
    /// UIViewController which is to be displayed at first. Default is 0
    func startViewPagerAtIndex()->Int
}

public protocol ViewPagerDelegate: AnyObject {
    
    func willMoveToControllerAtIndex(index:Int)
    func didMoveToControllerAtIndex(index:Int)
}

public class ViewPager: NSObject {
    
    fileprivate weak var dataSource:ViewPagerDataSource?
    fileprivate weak var delegate:ViewPagerDelegate?
    fileprivate weak var controller: UIViewController?
    fileprivate var view: UIView
    
    fileprivate var tabContainer = UIScrollView()
    fileprivate var pageController: UIPageViewController?
    
    fileprivate var tabIndicator = UIView()
    fileprivate var tabIndicatorLeadingConstraint: NSLayoutConstraint?
    fileprivate var tabIndicatorWidthConstraint: NSLayoutConstraint?
    
    fileprivate var tabsList = [ViewPagerTab]()
     var tabsViewList = [ViewPagerTabViewNew]() //fileprivate
    
    fileprivate var options = ViewPagerOptionsNew()
    fileprivate var currentPageIndex = 0
    
    
    
    /// Initializes the ViewPager class.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController in which this view pager is to be initialized
    ///   - containerView: Container view on which viewpager is to be shown. If its nil, default view of UIViewController is used
    public init(viewController: UIViewController, containerView: UIView? = nil) {
        self.controller = viewController
        self.view = containerView ?? viewController.view
    }
    
    
    /// Sets the customization options for ViewPager. This should be called before the build method.
    /// Setting of options is mandatory.
    ///
    /// - Parameter options: Customization options instance
    public func setOptions(options: ViewPagerOptionsNew) {
        self.options = options
    }
    
    
    /// Sets the datasource of the viewpager. This should be called before the build method.
    /// Setting of data source is mandatory.
    ///
    /// - Parameter dataSource: DataSource for this viewpager
    public func setDataSource(dataSource: ViewPagerDataSource) {
        self.dataSource = dataSource
    }
    
    
    /// Sets the delegates of the viewpager. This method is optional
    ///
    /// - Parameter delegate: Delegate for this viewpager.
    public func setDelegate(delegate: ViewPagerDelegate?) {
        self.delegate = delegate
    }
    
    
    /// Initiates the ViewPager creation process. It creates tabs, viewController pages, and tab indicator
    /// Make sure Options & ViewPagerDataSource is set before calling this method.
    public func build() {
        setupTabContainerView()
        setupPageViewController()
        setupTabAndIndicator()
    }

    
    // MARK:- Private Helpers
    
    fileprivate func setupTabContainerView() {
        
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabContainer)
        
        
       // setGradientBackground(tabView: tabContainer)
        //tabContainer.backgroundColor = options.tabViewBackgroundDefaultColor
        tabContainer.isScrollEnabled = true
        tabContainer.showsVerticalScrollIndicator = false
        tabContainer.showsHorizontalScrollIndicator = false
        
        tabContainer.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
        tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            tabContainer.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        } else {
            let marginGuide = view.layoutMarginsGuide
            tabContainer.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        }
        
        // Adding Gesture
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tabContainerTapped(_:)))
        tabContainer.addGestureRecognizer(tabViewTapGesture)
    }
    
    fileprivate func setupPageViewController() {
        
        let pageController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: .horizontal, options: nil)
        
        self.controller?.addChild(pageController)
        setupForAutolayout(view: pageController.view, inView: view)
        pageController.didMove(toParent: controller)
        self.pageController = pageController
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        self.pageController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.pageController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.pageController?.view.topAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
        self.pageController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        guard let viewPagerDataSource = dataSource else {
            fatalError("ViewPagerDataSource not set")
        }
        
        self.currentPageIndex = viewPagerDataSource.startViewPagerAtIndex()
        if let firstPageController = getPageItemViewController(atIndex: self.currentPageIndex) {
            
            self.pageController?.setViewControllers([firstPageController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK:- ViewPager Tab Setup
    
    fileprivate func setupTabAndIndicator() {
        
        guard let tabs = dataSource?.tabsForPages() else { return }
        self.tabsList = tabs
        
        switch options.distribution {
        case .segmented:
            setupTabsForSegmentedDistribution()
            
        case .normal:
            setupTabsForNormalAndEqualDistribution(distribution: .normal)
            
        case .equal:
            setupTabsForNormalAndEqualDistribution(distribution: .equal)
        }
        
        if options.isTabIndicatorAvailable {
            
            setupForAutolayout(view: tabIndicator, inView: tabContainer)
            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
            tabIndicator.heightAnchor.constraint(equalToConstant: options.tabIndicatorViewHeight).isActive = true
            tabIndicator.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            
            let activeTab = self.tabsViewList[currentPageIndex]
            
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            tabIndicatorLeadingConstraint?.isActive = true
            tabIndicatorWidthConstraint?.isActive = true
        }
        
        if options.isTabHighlightAvailable {
            self.tabsViewList[currentPageIndex].addHighlight(options: self.options)
        }
        
        
        if options.isTabHighlightAvailable {
            self.tabsViewList[currentPageIndex].addHighlight(options: self.options)
        }
        
        
        
        if options.isTabBarShadowAvailable {
            
            tabContainer.layer.masksToBounds = false
            tabContainer.layer.shadowColor = options.shadowColor.cgColor
            tabContainer.layer.shadowOpacity = options.shadowOpacity
            tabContainer.layer.shadowOffset = options.shadowOffset
            tabContainer.layer.shadowRadius = options.shadowRadius
            
            view.bringSubviewToFront(tabContainer)
        }
    }
    
    fileprivate func setupTabsForNormalAndEqualDistribution(distribution: ViewPagerOptionsNew.Distribution) {
        
        var maxWidth: CGFloat = 0
        
        var lastTab: ViewPagerTabViewNew?
        
        for (index, eachTab) in tabsList.enumerated() {
            
            let tabView = ViewPagerTabViewNew()
            setupForAutolayout(view: tabView, inView: tabContainer)
            
            tabView.backgroundColor = options.tabViewBackgroundDefaultColor
            tabView.setup(tab: eachTab, options: options)
            
            if let previousTab = lastTab {
                tabView.leadingAnchor.constraint(equalTo: previousTab.trailingAnchor).isActive = true
            } else {
                tabView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor).isActive = true
            }
            
            tabView.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
            
            tabView.tag = index
            tabsViewList.append(tabView)
            
            maxWidth = max(maxWidth, tabView.width)
            lastTab = tabView
        }
        
        lastTab?.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor).isActive = true
        
        // Second pass to set Width for all tabs
        tabsViewList.forEach { tabView in
            
            switch distribution {
                
            case .normal:
                tabView.widthAnchor.constraint(equalToConstant: tabView.width).isActive = true
            case .equal:
                tabView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
            default:
                break
            }
        }
    }
    
    
    fileprivate func setupTabsForSegmentedDistribution() {
        
        var lastTab: ViewPagerTabViewNew?
        
        let tabCount = CGFloat(self.tabsList.count)
        let distribution = CGFloat(1.0 / tabCount)
        
        for (index, eachTab) in self.tabsList.enumerated() {
            
            let tabView = ViewPagerTabViewNew()
            setupForAutolayout(view: tabView, inView: tabContainer)
            
            
            
           // tabView.backgroundColor = options.tabViewBackgroundDefaultColor
            
            
            if let previousTab = lastTab {
                tabView.leadingAnchor.constraint(equalTo: previousTab.trailingAnchor).isActive = true
            } else {
                tabView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor).isActive = true
            }
            
            tabView.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
            tabView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: distribution).isActive = true
            
            tabView.setup(tab: eachTab, options: options)
            
            tabView.tag = index
            tabsViewList.append(tabView)
            
            lastTab = tabView
        }
        
        lastTab?.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor).isActive = true
    }
    
    /// Sets up indicator for the page if enabled in ViewPagerOption. This method shows either tabIndicator or Highlights current tab or both.
    fileprivate func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
        
        self.currentPageIndex = currentIndex
        
        let activeTab = tabsViewList[currentIndex]
        let activeFrame = activeTab.frame
        
        // Setup Tab Highlight
        if options.isTabHighlightAvailable {
            
            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.tabsViewList[currentIndex].addHighlight(options: self.options)
            })
        }
        
        if options.isTabIndicatorAvailable {
            
            // Deactivate previous contstraint
            tabIndicatorLeadingConstraint?.isActive = false
            tabIndicatorWidthConstraint?.isActive = false
            
            // Create new ones to activate within animation block
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                
                self.tabIndicatorWidthConstraint?.isActive = true
                self.tabIndicatorLeadingConstraint?.isActive = true
                
                self.tabContainer.scrollRectToVisible(activeFrame, animated: false)
                self.tabContainer.layoutIfNeeded()
            }
            
            return
        }
        
        self.tabContainer.scrollRectToVisible(activeFrame, animated: true)
    }
    
    
    /// Returns UIViewController for page at provided index.
    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
        
        guard let viewPagerSource = dataSource, index >= 0 && index < viewPagerSource.numberOfPages() else {
            return nil
        }
        
        let pageItemViewController = viewPagerSource.viewControllerAtPosition(position: index)
        pageItemViewController.view.tag = index
        
        return pageItemViewController
    }
    
    
    /// Displays the UIViewController provided at given index in datasource.
    ///
    /// - Parameter index: position of the view controller to be displayed. 0 is first UIViewController
    public func displayViewController(atIndex index:Int) {
        
        guard let chosenViewController = getPageItemViewController(atIndex: index) else {
            fatalError("There is no view controller for tab at index: \(index)")
        }
        
        let previousIndex = currentPageIndex
        let direction:UIPageViewController.NavigationDirection = (index > previousIndex ) ? .forward : .reverse
        
        
        delegate?.willMoveToControllerAtIndex(index: index)
        setupCurrentPageIndicator(currentIndex: index, previousIndex: currentPageIndex)
        
        /* Wierd bug in UIPageViewController. Due to caching, in scroll transition mode,
         wrong cached view controller is shown. This is the common workaround */
        pageController?.setViewControllers([chosenViewController], direction: direction, animated: true, completion: { (isCompleted) in
            
            DispatchQueue.main.async { [unowned self] in
                
                self.pageController?.setViewControllers([chosenViewController], direction: direction, animated: false, completion: { (isComplete) in
                    
                    guard isComplete else { return }
                    
                    
                    //TODO
                    
//                    for i in 0..<tabsViewList.count {
//                        if(index == i){
//                            self.tabsViewList[i].adjustFontSize(fontSize: 16.0)
//                        }else{
//                            self.tabsViewList[i].adjustFontSize(fontSize: 14.0)
//                        }
//
//                    }
//
//                    tabsViewList.forEach { tabView in
//
//
//                      //  tabView.
//                        switch distribution {
//
//                        case .normal:
//                            tabView.widthAnchor.constraint(equalToConstant: tabView.width).isActive = true
//                        case .equal:
//                            tabView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
//                        default:
//                            break
//                        }
//                    }
//                    
//
                    
                    self.delegate?.didMoveToControllerAtIndex(index: index)
                    
                })
            }
        })
    }
    
    /// Invalidate the current tab layout and causes the layout to be drawn again.
    public func invalidateCurrentTabs() {
        
        // Removing all the tabs from tabContainer
        _ = tabsViewList.map({ $0.removeFromSuperview() })
        
        tabIndicator = UIView()
        tabIndicatorLeadingConstraint?.isActive = false
        tabIndicatorWidthConstraint?.isActive = false
        
        tabsList.removeAll()
        tabsViewList.removeAll()
        
        setupTabAndIndicator()
    }
    
    
    // MARK:- Actions
    @objc func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tabContainer)
        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
        
        if let tabIndex = tabViewTapped?.tag, tabIndex != currentPageIndex {
            displayViewController(atIndex: tabIndex)
        }
    }
}

extension ViewPager: UIPageViewControllerDataSource {
    
    /* ViewController the user will navigate to in backward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let previousController = getPageItemViewController(atIndex: viewController.view.tag - 1)
        return previousController
    }
    
    /* ViewController the user will navigate to in forward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let nextController = getPageItemViewController(atIndex: viewController.view.tag + 1)
        return nextController
    }
}


extension ViewPager: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let pageIndex = pageViewController.viewControllers?.first?.view.tag else { return }
        
        if completed && finished {
            
            setupCurrentPageIndicator(currentIndex: pageIndex, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex(index: pageIndex)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex(index: pageIndex!)
    }
    
    
    internal func setupForAutolayout(view: UIView?, inView parentView: UIView) {
        
        guard let v = view else { return }
        
        v.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(v)
    }
}
//import UIKit
//
//@objc public protocol ViewPagerControllerDelegate {
//
//    @objc optional func willMoveToControllerAtIndex(index:Int)
//    @objc optional func didMoveToControllerAtIndex(index:Int)
//}
//
//public protocol ViewPagerControllerDataSource: class {
//
//    /// Number of pages to be displayed
//    func numberOfPages() -> Int
//
//    /// ViewController for required page position
//    func viewControllerAtPosition(position:Int) -> UIViewController
//
//    /// Tab structure of the pages
//    func tabsForPages() -> [ViewPagerTab]
//
//    /// UIViewController which is to be displayed at first. Default is 0
//    func startViewPagerAtIndex()->Int
//}
//
//public extension ViewPagerControllerDataSource {
//
//    func startViewPagerAtIndex() -> Int {
//        return 0
//    }
//}
//
//public class ViewPagerController:UIViewController {
//
//    public weak var dataSource:ViewPagerControllerDataSource!
//    public weak var delegate:ViewPagerControllerDelegate?
//
//    public var tabContainer:UIScrollView!
//
//    fileprivate var pageViewController:UIPageViewController!
//    fileprivate lazy var tabIndicator = UIView()
//
//    fileprivate var tabsList = [ViewPagerTab]()
//    fileprivate var tabsViewList = [ViewPagerTabView]()
//
//    fileprivate var isIndicatorAdded = false
//    fileprivate var currentPageIndex = 0
//
//    public var options:ViewPagerOptions!
//
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.view.frame = options.viewPagerFrame
//
//        setupTabContainerView()
//        setupTabs()
//        createPageViewController()
//    }
//
//    override public func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        self.view.frame = options.viewPagerFrame
//        setupPageControllerFrame()
//    }
//
//    /*--------------------------
//     MARK:- Viewpager tab setup
//     ---------------------------*/
//
//    /// Prepares the container for holding all the tabviews.
//    fileprivate func setupTabContainerView() {
//
//        let viewPagerFrame = options.viewPagerFrame
//
//        // Creating container for Tab View
//        tabContainer = UIScrollView()
//        tabContainer = UIScrollView(frame: CGRect(x: 0, y:0, width: viewPagerFrame.width, height: options.tabViewHeight))
//        tabContainer.backgroundColor = options.tabViewBackgroundDefaultColor
//        tabContainer.isScrollEnabled = true
//        tabContainer.showsVerticalScrollIndicator = false
//        tabContainer.showsHorizontalScrollIndicator = false
//
//        // Adding Gesture
//        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewPagerController.tabContainerTapped(_:)))
//        tabContainer.addGestureRecognizer(tabViewTapGesture)
//
//        // For Landscape mode, Setting up VFL
//        tabContainer.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(tabContainer)
//
//        self.view.backgroundColor = UIColor.white
//
//        let viewDict:[String:UIView] = ["v0":self.tabContainer]
//        let metrics:[String:CGFloat] = ["tabViewHeight":options.tabViewHeight]
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: metrics, views: viewDict))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(tabViewHeight)]", options: NSLayoutConstraint.FormatOptions(), metrics: metrics, views: viewDict))
//    }
//
//
//
//    ///Creates and adds each tabs according to the options provided in tabcontainer.
//    fileprivate func setupTabs() {
//
//        var totalWidth:CGFloat = 0
//        self.tabsList = dataSource.tabsForPages()
//
//        if options.fitAllTabsInView {
//
//            let viewPagerFrame = options.viewPagerFrame
//
//            // Calculating width for each tab
//            let eachLabelWidth = viewPagerFrame.width / CGFloat (tabsList.count)
//            totalWidth = viewPagerFrame.width * CGFloat(tabsList.count)
//
//            // Creating view for each tab. Width for each tab is provided.
//            for (index,eachTab) in tabsList.enumerated() {
//
//                let xPosition = CGFloat(index) * eachLabelWidth
//                let tabView = ViewPagerTabView()
//                tabView.frame = CGRect(x: xPosition, y: 0, width: eachLabelWidth, height: options.tabViewHeight)
//                tabView.setup(tab: eachTab, options: options, condition: ViewPagerTabView.SetupCondition.fitAllTabs)
//
//                tabView.tag = index
//                tabsViewList.append(tabView)
//                tabContainer.addSubview(tabView)
//            }
//
//        } else {
//
//            var maxWidth:CGFloat = 0
//
//            for (index,eachTab) in tabsList.enumerated() {
//
//                let tabView = ViewPagerTabView()
//                let dummyFrame = CGRect(x: totalWidth, y: 0, width: 0, height: options.tabViewHeight)
//                tabView.frame = dummyFrame
//
//                // Creating tabs using their intrinsic content size.
//                tabView.setup(tab: eachTab, options: options, condition: ViewPagerTabView.SetupCondition.distributeNormally)
//
//                if !options.isEachTabEvenlyDistributed {
//
//                    tabContainer.addSubview(tabView)
//                }
//
//                tabView.tag = index
//                tabsViewList.append(tabView)
//                totalWidth += tabView.frame.width
//                maxWidth = getMaximumWidth(maxWidth: maxWidth, withWidth: tabView.frame.width)
//            }
//
//            // Incase each tabs are evenly distributed, width is the maximum width among view tabs
//            if options.isEachTabEvenlyDistributed {
//
//                for (index,eachTabView) in tabsViewList.enumerated() {
//
//                    eachTabView.updateFrame(atIndex: index, withWidth: maxWidth, options: options)
//                    tabContainer.addSubview(eachTabView)
//                }
//
//                totalWidth = maxWidth * CGFloat(tabsViewList.count)
//            }
//
//            tabContainer.contentSize = CGSize(width: totalWidth, height: options.tabViewHeight)
//        }
//    }
//
//
//    /// Sets up indicator for the page if enabled in ViewPagerOption. This method shows either tabIndicator or Highlights current tab or both.
//    fileprivate func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
//
//        if options.isTabHighlightAvailable {
//
//            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
//
//            UIView.animate(withDuration: 0.8, animations: {
//
//                self.tabsViewList[currentIndex].addHighlight(options: self.options)
//            })
//        }
//
//        self.currentPageIndex = currentIndex
//
//        let currentTabFrame = tabsViewList[currentIndex].frame
//        var tabIndicatorFrame:CGRect!
//
//        if options.isTabIndicatorAvailable {
//
//            let indicatorWidth = currentTabFrame.width
//            let indicatorHeight = options.tabIndicatorViewHeight
//            let xPosition:CGFloat = currentTabFrame.origin.x
//            let yPosition = options.tabViewHeight - options.tabIndicatorViewHeight
//
//            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
//
//            let dummyFrame = CGRect(x: xPosition, y: yPosition, width: 0, height: indicatorHeight)  // for animating purpose
//            tabIndicatorFrame = CGRect(x: xPosition, y: yPosition, width: indicatorWidth, height: indicatorHeight)
//
//            if !isIndicatorAdded {
//
//                tabIndicator.frame = dummyFrame
//                tabContainer.addSubview(tabIndicator)
//                isIndicatorAdded = true
//            }
//
//            self.tabContainer.bringSubviewToFront(tabIndicator)
//
//            UIView.animate(withDuration: 0.5, animations: {
//
//                self.tabContainer.scrollRectToVisible(tabIndicatorFrame, animated: false)
//                self.tabIndicator.frame = tabIndicatorFrame
//                self.tabIndicator.layoutIfNeeded()
//            })
//
//            return
//        }
//
//        // Just animate the scrolling if indicator is not available
//        UIView.animate(withDuration: 0.5) {
//
//            self.tabContainer.scrollRectToVisible(currentTabFrame, animated: false)
//        }
//
//    }
//
//    /*--------------------------
//     MARK:- Tab setup helpers
//     ---------------------------*/
//
//    /// Gesture recognizer for determining which tabview was tapped
//    @objc func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
//
//        let tapLocation = recognizer.location(in: self.tabContainer)
//        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
//
//        let tabViewIndex = tabViewTapped?.tag
//
//        if tabViewIndex != currentPageIndex {
//
//            displayViewController(atIndex: tabViewIndex ?? 0)
//        }
//    }
//
//    /// Determines the orientation change and sets up the tab size and its indicator size accordingly.
//    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        DispatchQueue.main.async {
//
//            if self.options.fitAllTabsInView {
//
//                let tabContainerWidth = self.tabContainer.frame.size.width
//                let tabViewWidth = tabContainerWidth / CGFloat (self.tabsList.count)
//
//                if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isPortrait {
//
//                    for (index,eachTab ) in self.tabsViewList.enumerated() {
//
//                        eachTab.updateFrame(atIndex: index, withWidth: tabViewWidth, options: self.options)
//                    }
//
//                    self.tabContainer.contentSize = CGSize(width: tabContainerWidth, height: self.options.tabViewHeight)
//                }
//
//                self.setupCurrentPageIndicator(currentIndex: self.currentPageIndex, previousIndex: self.currentPageIndex)
//            }
//        }
//    }
//
//    /// Determines maximum width between two provided value and returns it
//    fileprivate func getMaximumWidth(maxWidth:CGFloat, withWidth currentWidth:CGFloat) -> CGFloat {
//
//        return (maxWidth > currentWidth) ? maxWidth : currentWidth
//    }
//
//
//    /*--------------------------------
//     MARK:- PageViewController Helpers
//     --------------------------------*/
//
//    fileprivate func createPageViewController() {
//
//        pageViewController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
//
//        setupPageControllerFrame()
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//
//        if dataSource.numberOfPages() > 0 {
//
//            currentPageIndex = dataSource.startViewPagerAtIndex()
//            let firstController = getPageItemViewController(atIndex: currentPageIndex)!
//            pageViewController.setViewControllers([firstController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
//        }
//
//        self.addChild(pageViewController)
//        self.view.addSubview(pageViewController.view)
//        self.pageViewController.didMove(toParent: self)
//
//        setupCurrentPageIndicator(currentIndex: currentPageIndex, previousIndex: currentPageIndex)
//    }
//
//    // PageViewController Frame Setup
//
//    fileprivate func setupPageControllerFrame() {
//
//        let viewPagerFrame = options.viewPagerFrame
//        let viewPagerHeight = options.viewPagerFrame.height - options.tabViewHeight - options.viewPagerFrame.origin.y
//
//        let pageControllerFrame = CGRect(x: viewPagerFrame.origin.x, y: options.tabViewHeight, width: viewPagerFrame.width, height: viewPagerHeight)
//        pageViewController.view.frame = pageControllerFrame
//    }
//
//    /// Returns UIViewController for page at provided index.
//    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
//
//        if index >= 0 && index < dataSource.numberOfPages() {
//
//            let pageItemViewController = dataSource.viewControllerAtPosition(position: index)
//            pageItemViewController.view.tag = index
//
//            return pageItemViewController
//        }
//
//        return nil
//    }
//
//
//    /// Displays the UIViewController provided at given index in datasource.
//    ///
//    /// - Parameter index: position of the view controller to be displayed. 0 is first UIViewController
//    public func displayViewController(atIndex index:Int) {
//
//        let chosenViewController = getPageItemViewController(atIndex: index)!
//        delegate?.willMoveToControllerAtIndex?(index: index)
//
//        let previousIndex = currentPageIndex
//        let direction:UIPageViewController.NavigationDirection = (index > previousIndex ) ? .forward : .reverse
//        setupCurrentPageIndicator(currentIndex: index, previousIndex: currentPageIndex)
//
//        /* Wierd bug in UIPageViewController. Due to caching, in scroll transition mode,
//         wrong cached view controller is shown. This is the common workaround */
//
//        pageViewController.setViewControllers([chosenViewController], direction: direction, animated: true, completion: { (isCompleted) in
//
//            DispatchQueue.main.async { [weak self] in
//                self?.pageViewController.setViewControllers([chosenViewController], direction: direction, animated: false, completion: { (isCompleted) in
//
//                    if isCompleted {
//                        self?.delegate?.didMoveToControllerAtIndex?(index: index)
//                    }
//                })
//            }
//
//        })
//    }
//
//    /// Invalidate the current tabs shown and reloads the new tabs provided in datasource.
//    public func invalidateTabs() {
//
//        // Removing all the tabs from tabContainer
//        _ = tabsViewList.map({ $0.removeFromSuperview() })
//
//        tabsList.removeAll()
//        tabsViewList.removeAll()
//
//        setupTabs()
//        setupCurrentPageIndicator(currentIndex: currentPageIndex, previousIndex: currentPageIndex)
//    }
//
//}
//
//// MARK:- UIPageViewController Delegates
//
//extension ViewPagerController: UIPageViewControllerDelegate {
//
//    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        if completed && finished {
//
//            let pageIndex = pageViewController.viewControllers?.first?.view.tag
//            setupCurrentPageIndicator(currentIndex: pageIndex!, previousIndex: currentPageIndex)
//            delegate?.didMoveToControllerAtIndex?(index: pageIndex!)
//        }
//    }
//
//    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//
//        let pageIndex = pendingViewControllers.first?.view.tag
//        delegate?.willMoveToControllerAtIndex?(index: pageIndex!)
//    }
//}
//
//// MARK:- UIPageViewController Datasource
//
//extension ViewPagerController:UIPageViewControllerDataSource {
//
//    /* ViewController the user will navigate to in backward direction */
//    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//        return getPageItemViewController(atIndex: viewController.view.tag - 1)
//    }
//
//    /* ViewController the user will navigate to in forward direction */
//    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//        return getPageItemViewController(atIndex: viewController.view.tag + 1)
//    }
//
//}
//
