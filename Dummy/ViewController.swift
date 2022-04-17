//
//  ViewController.swift
//  Dummy
//
//  Created by Goldmedal on 15/09/21.
//

import UIKit

class ViewController: UIViewController,CommonDelegate{
    
    var appStoreVersionNumber : Double?
    var forceUpdate = false
    
    private var presenter: iAuthPresenter!
    private var refreshToken: [InitialToken] = []
    private var initialData: [InitialData] = []
    
    var mobileNo = String()
    var deviceDetail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        mobileNo = UserDefaults.standard.value(forKey: "MobileNumber") as? String ?? ""
        deviceDetail = "\(UIDevice().type.rawValue) (\(Utility.getDeviceId() ?? ""))"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.getInitialData(callFrom: Constant.INITIAL_API)
    }
    
    
    func isUpdateAvailable(appstoreVersion: Double) -> Bool {
        guard let info = Bundle.main.infoDictionary,
              let version = info["CFBundleShortVersionString"] as? String else {
                  return false
              }
        
        let appVersion = Double(version)
        let appStoreVersion = appstoreVersion
        return CGFloat(appVersion ?? 0) < CGFloat(appStoreVersion)
    }
    
    
    func continueInsideApp(){
        if(!Utility.getToken().isEmpty){
            presenter.refreshToken(phoneNo: mobileNo, deviceId: deviceDetail, callFrom: Constant.TOKEN_REFRESH)
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController!.pushViewController(vcLogin, animated: false)
        }
    }
    
    func refreshApi() {
        continueInsideApp()
    }
    
}

extension ViewController : AuthPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.TOKEN_REFRESH){
            refreshToken = presenter.refreshToken
            var token = refreshToken[0].accessToken ?? ""
            var time = refreshToken[0].expiresIn ?? 0 // - - - -  incase if we need to call this in splash
            
            UserDefaults.standard.set(token, forKey: "Token")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            self.navigationController?.pushViewController(vcHome, animated: false)
            
        }
        
        if(callFrom == Constant.INITIAL_API){
            initialData = presenter.initialData
            if(initialData.count>0){
                appStoreVersionNumber = initialData[0].ios ?? 0.0
                if(isUpdateAvailable(appstoreVersion: appStoreVersionNumber ?? 1.0)){
                    //show force update
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                    let vcUpdatePopup = storyBoard.instantiateViewController(withIdentifier: "ForceUpdatePopupController") as! ForceUpdatePopupController
                    vcUpdatePopup.appVersion = String(appStoreVersionNumber ?? 1.0)
                    vcUpdatePopup.delegate = self
                    self.present(vcUpdatePopup, animated: false)
                    
                    
                }else{
                    continueInsideApp()
                }
            }else{
                continueInsideApp()
            }
            
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.refreshToken(phoneNo: mobileNo, deviceId: deviceDetail, callFrom: Constant.TOKEN_REFRESH)
        }else{
            let alertController = UIAlertController(title: "Error", message: "Currently we are experiencing server error, Please try again later!!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action:UIAlertAction!) in
                exit(0)
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
}


