//
//  ViewControllerUtils.swift
//  dealersApp
//
//  Created by Goldmedal on 4/26/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerUtils: NSObject {
    
    static let sharedInstance = ViewControllerUtils()
    private var activityIndicator = UIActivityIndicatorView()
    
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    //MARK: - Private Methods -
    private func setupLoader() {
        removeLoader()
        DispatchQueue.main.async {
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator = UIActivityIndicatorView(style: .white)
        }
        // activityIndicator.activityIndicatorViewStyle = .whiteLarge
        //        if #available(iOS 11.0, *) {
        //            activityIndicator.color = UIColor.init(named: "FontDarkText")
        //        } else {
        //            activityIndicator.color = UIColor.darkGray
        //        }
        
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = "Loading"
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
    }
    
    
    
    //MARK: - Public Methods -
    func showLoader() {
        setupLoader()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let holdingView = appDel.window!.rootViewController!.view!
        
        DispatchQueue.main.async {
            self.activityIndicator.center = holdingView.center
            self.activityIndicator.startAnimating()
            
            self.effectView.frame = CGRect(x: holdingView.frame.midX - self.strLabel.frame.width/2, y: holdingView.frame.midY - self.strLabel.frame.height/2 , width: 160, height: 46)
            
            self.effectView.contentView.addSubview(self.strLabel)
            self.effectView.contentView.addSubview(self.activityIndicator)
            holdingView.addSubview(self.effectView)
            
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    
    func showViewLoader(view: UIView) {
        setupLoader()
        
        DispatchQueue.main.async {
            //            self.activityIndicator.center = view.center
            //            self.activityIndicator.startAnimating()
            //            view.addSubview(self.activityIndicator)
            
            self.activityIndicator.center = view.center
            self.activityIndicator.startAnimating()
            
            self.effectView.frame = CGRect(x: view.frame.midX - self.strLabel.frame.width/2, y: view.frame.midY - self.strLabel.frame.height/2 , width: 160, height: 46)
            
            self.effectView.contentView.addSubview(self.strLabel)
            self.effectView.contentView.addSubview(self.activityIndicator)
            view.addSubview(self.effectView)
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            self.strLabel.removeFromSuperview()
            self.effectView.removeFromSuperview()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    //For no internet connection and no data check
    func showNoData(view: UIView,from:String) {
        
        var viewNoData = UIView()
        
        if(from.isEqual("NDA"))
        {
            var tmp = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil);
            viewNoData = tmp?[0] as! UIView;
        }
        else if(from.isEqual("ERR"))
        {
            var tmp = Bundle.main.loadNibNamed("ErrorView", owner: nil, options: nil);
            viewNoData = tmp?[0] as! UIView;
        }
        else if(from.isEqual("NET"))
        {
            var tmp = Bundle.main.loadNibNamed("NoInternetView", owner: nil, options: nil);
            viewNoData = tmp?[0] as! UIView;
        }
        viewNoData.center = CGPoint(x: view.bounds.size.width / 2.0, y: viewNoData.bounds.size.height / 2.0);
        view.addSubview(viewNoData)
        view.isHidden = false
    }
    
    func removeNoData(view: UIView){
        view.isHidden = true
    }
    
}


public class NoDataView : UIView {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblNoData: UILabel!
 //   @IBOutlet weak var imvNoData: UIImageView!
   // @IBOutlet weak var btnRetry: UIButton!
    // var delegate: RetryApi?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init (from:String) {
        self.init(frame:CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadViewFromNib()
        
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "NoDataView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        return view
        
    }
    
    
    func showView(view:UIView,from:String,msg:String?){
        DispatchQueue.main.async {
            
            view.isHidden = false
            view.isUserInteractionEnabled = false
            
            
            if(from.isEqual("LOADER")){
                self.loader.isHidden = false
                self.lblNoData.text = ""
            }else{
                self.loader.isHidden = true
                self.lblNoData.text = msg ?? "No Data Available"
            }
//            if(from.isEqual("NDA")){
//                self.lblNoData.text = "No Data Available"
//             //   self.imvNoData.image = UIImage(named:"icon_no_data")
//                self.loader.isHidden = true
//            }else if(from.isEqual("ERR")){
//                self.lblNoData.text = "Server Error"
//             //   self.imvNoData.image = UIImage(named:"icon_error")
//                self.loader.isHidden = true
//            }else if(from.isEqual("NET")){
//                self.lblNoData.text = "No Internet Connection"
//            //    self.imvNoData.image = UIImage(named:"icon_no_internet")
//                self.loader.isHidden = true
//            }else if(from.isEqual("LOADER")){
//                self.loader.isHidden = false
//          //      self.imvNoData.image = nil
//                self.lblNoData.text = ""
//            }
        }
    }
    
    func hideView(view:UIView){
        DispatchQueue.main.async {
            view.isHidden = true
            view.isUserInteractionEnabled = false
            self.loader.isHidden = true
        }
    }
    
    
    func showTransparentView(view:UIView,from:String){
        viewNoData.backgroundColor = UIColor.clear
        view.isHidden = false
        view.isUserInteractionEnabled = false
        if(from.isEqual("LOADER")){
            loader.isHidden = false
         //   imvNoData.image = nil
            lblNoData.text = ""
        }
    }

}


// - - - -  For header - - - -
public class HeaderView : UIView {

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imvBack: UIImageView!

    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init (from:String) {
        self.init(frame:CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadHeaderViewFromNib()
        
    }
    
    
    func loadHeaderViewFromNib() -> UIView {
        
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "HeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        return view
        
    }
}



extension UIView{

    func activityStartAnimating() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.tag = 123
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        self.addSubview(backgroundView)
    }


    func activityStopAnimating() {
        if let background = viewWithTag(123){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
