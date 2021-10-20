//
//  ViewPagerTabViewNew.swift
//  Dummy
//
//  Created by Apple on 19/10/21.
//

import UIKit

public final class ViewPagerTabViewNew: UIView {
    
    internal var titleLabel:UILabel?
    internal var imageView:UIImageView?
    internal var width: CGFloat = 0
    
    
    
    private var gradientLayer: CAGradientLayer!
    
    private var options: ViewPagerOptionsNew?
    
    /*--------------------------
     MARK:- Initialization
     ---------------------------*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*--------------------------
     MARK:- Tab Setup
     ---------------------------*/
    
    /**
     Sets up tabview for ViewPager. The type of tabview is automatically obtained from
     the options passed in this function.
     */
    internal func setup(tab:ViewPagerTab, options:ViewPagerOptionsNew) {
        self.options = options
        switch options.tabType {
            
        case ViewPagerTabType.basic:
            setupBasicTab(options: options, tab: tab)
            
        case ViewPagerTabType.image:
            setupImageTab(withText: false,options: options, tab:tab)
            
        case ViewPagerTabType.imageWithText:
            setupImageTab(withText: true, options: options, tab:tab)
        }
    }
    
    
    /**
     * Creates tab containing only one label with provided options and add it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Does not consider the padding provided from ViewPagerOptions.
     *
     * Case DistributeNormally: Creates a tabview. Width is calculated from title intrinsic size. Considers the padding
     * provided from options too.
     */
    fileprivate func setupBasicTab(options:ViewPagerOptionsNew, tab:ViewPagerTab) {
        
        buildTitleLabel(withOptions: options, text: tab.title)
        //addGradientBackground(withOptions: options)
        
        setupForAutolayout(view: titleLabel)
        
        titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        let distribution = options.distribution
        
        guard distribution == .equal || distribution == .normal else { return }
        
        let labelWidth = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
        self.width = labelWidth
    }
    
    /**
     * Creates tab containing image or image with text. And adds it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Doesnot consider padding provided from ViewPagerOptions.
     * ImageView is centered inside tabview if tab type is Image only. Else image margin are used to calculate the position
     * in case of tab type ImageWithText.
     *
     * Case DistributeNormally: Creates a tabView. Width is automatically calculated either from imagesize or text whichever
     * is larger. ImageView is centered inside tabview with provided paddings if tab type is Image only. Considers both padding
     * and image margin incase tab type is ImageWithText.
     */
    fileprivate func setupImageTab(withText:Bool, options:ViewPagerOptionsNew, tab:ViewPagerTab) {
        
        let distribution = options.distribution
        
        let imageSize = options.tabViewImageSize
        
        switch distribution {
            
        case .segmented:
            
            if withText {
                
                buildImageView(withOptions: options, image: tab.image)
                buildTitleLabel(withOptions: options, text: tab.title)
                
                setupForAutolayout(view: imageView)
                imageView?.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
                imageView?.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
                imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                imageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: options.tabViewImageMarginTop).isActive = true
                
                setupForAutolayout(view: titleLabel)
                titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                titleLabel?.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: options.tabViewImageMarginBottom).isActive = true
                titleLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                
            } else {
                
                buildImageView(withOptions: options, image: tab.image)
                
                setupForAutolayout(view: imageView)
                imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                imageView?.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
                imageView?.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
            }
            
            
        case .normal,.equal:
            
            if withText {
                
                buildImageView(withOptions: options, image: tab.image)
                buildTitleLabel(withOptions: options, text: tab.title)
                
                setupForAutolayout(view: imageView)
                imageView?.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
                imageView?.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
                imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                imageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: options.tabViewImageMarginTop).isActive = true
                
                setupForAutolayout(view: titleLabel)
                titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                titleLabel?.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: options.tabViewImageMarginBottom).isActive = true
                titleLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                
                // Resetting tabview frame again with the new width
                let widthFromImage = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                let widthFromText = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
                let tabWidth = max(widthFromImage, widthFromText)
                self.width = tabWidth
                
            } else {
                
                // Creating imageview
                buildImageView(withOptions: options, image: tab.image)
                
                setupForAutolayout(view: imageView)
                imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                imageView?.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
                imageView?.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
                
                // Determining the max width this tab should use
                let tabWidth = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                self.width = tabWidth
            }
        }
    }
    
    /*--------------------------
     MARK:- Helper Methods
     ---------------------------*/
    
    
    fileprivate func buildTitleLabel(withOptions options:ViewPagerOptionsNew, text:String) {
        
        titleLabel = UILabel()
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = options.tabViewTextDefaultColor
        titleLabel?.numberOfLines = 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = options.tabViewTextFont
        titleLabel?.text = text
    }
    
    
//    fileprivate func buildTitleLabel(withOptions options:ViewPagerOptionsNew, text:String) {
//
//        titleLabel = UILabel()
//        titleLabel?.textAlignment = .center
//        titleLabel?.textColor = options.tabViewTextDefaultColor
//        titleLabel?.numberOfLines = 2
//        titleLabel?.adjustsFontSizeToFitWidth = true
//        titleLabel?.font = options.tabViewTextFont
//        titleLabel?.text = text
//    }
    
    fileprivate func addGradientBackground(withOptions options:ViewPagerOptionsNew?) {
        
        let gradientLayer = CAGradientLayer()
      //  gradientLayer.frame = self.bounds
        gradientLayer.colors = [options?.tabViewTopGradientColor.cgColor ?? UIColor.black.cgColor, options?.tabViewBottomGradientColor.cgColor ?? UIColor.black.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.bounds
        
        
    }
    
    fileprivate func buildImageView(withOptions options:ViewPagerOptionsNew, image:UIImage?) {
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = image
    }
    
    
    internal func adjustFontSize(fontSize:CGFloat) {
        self.titleLabel?.font = self.titleLabel?.font.withSize(fontSize)
    }
    
    internal func addHighlight(options:ViewPagerOptionsNew) {
        
        self.backgroundColor = options.tabViewBackgroundHighlightColor
        self.titleLabel?.textColor = options.tabViewTextHighlightColor
    }
    
    internal func addGradientBackground(options:ViewPagerOptionsNew) {
        
     //   self.bac = options.tabViewBackgroundHighlightColor
      //  self.titleLabel?.textColor = options.tabViewTextHighlightColor
    }
    
    internal func removeHighlight(options:ViewPagerOptionsNew) {
        
        self.backgroundColor = options.tabViewBackgroundDefaultColor
        self.titleLabel?.textColor = options.tabViewTextDefaultColor
    }
    
    internal func setupForAutolayout(view: UIView?) {
        
        guard let v = view else { return }
        
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
    }
    
    @IBInspectable var topColor: UIColor = .red {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var bottomColor: UIColor = .yellow {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var shadowColor: UIColor = .clear {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var shadowX: CGFloat = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var shadowY: CGFloat = -3 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var shadowBlur: CGFloat = 3 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var startPointX: CGFloat = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var startPointY: CGFloat = 0 {//0.5
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var endPointX: CGFloat = 1 {
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var endPointY: CGFloat =  1{//0.5
            didSet {
                setNeedsLayout()
            }
        }
        
        @IBInspectable var cornerRadius: CGFloat = 0 {
            didSet {
                setNeedsLayout()
            }
        }
        
    public override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }
  
    
    
    public override func layoutSubviews() {
           super.layoutSubviews()
        addGradientBackground(withOptions: options)
        //self.gradientLayer = self.layer as? CAGradientLayer
       //    gradientLayer.frame = bounds
       }
        
//    public override func layoutSubviews() {
//            self.gradientLayer = self.layer as? CAGradientLayer
//
//
//
//
//
//
//            self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//
////        let gradientLayer = CAGradientLayer()
////        gradientLayer.colors = [colorTop, colorBottom]
////        gradientLayer.locations = [0.0, 1.0]
////        gradientLayer.frame = tabView.bounds
//
////        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
////        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//
//            self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
//            self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
//            self.layer.cornerRadius = cornerRadius
//            self.layer.shadowColor = shadowColor.cgColor
//            self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
//            self.layer.shadowRadius = shadowBlur
//            self.layer.shadowOpacity = 1
//
//
//        }
        
//        func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
//            let fromColors = self.gradientLayer?.colors
//            let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
//            self.gradientLayer?.colors = toColors
//            let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
//            animation.fromValue = fromColors
//            animation.toValue = toColors
//            animation.duration = duration
//            animation.isRemovedOnCompletion = true
//            animation.fillMode = .forwards
//            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//            self.gradientLayer?.add(animation, forKey:"animateGradient")
//        }
}
