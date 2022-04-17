//
//  LoginController.swift
//  Dummy
//
//  Created by Apple on 09/11/21.
//

import UIKit
import SVPinView

import CountryPickerView

struct AuthPayloadObj:Codable{
    var un:String
    var rcode:String
    var dm: String
    var os: String
    var cc: String
    var em: String
    var l: String
    var it: Bool
    var r: Bool
    var eot: String
    var s: String
    var t: Int = 0
    
    init(un:String,rcode:String,dm:String,os:String,cc:String,em:String,l:String,it:Bool,r:Bool,eot:String,s:String,t:Int) //,?
    {
        self.un = un
        self.rcode = rcode
        self.dm = dm
        self.os = os
        self.cc = cc
        self.em = em
        self.l = l
        self.it = it
        self.r = r
        self.eot = eot
        self.s = s
        self.t = t
    }
    
}


class LoginController: BaseViewController ,CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var textFieldRefCode: UITextField!
    @IBOutlet weak var textFieldMobileNo: UITextField!
    
    @IBOutlet weak var vwSelectCountry: UIView!
    @IBOutlet weak var vwUserInput: UIView!
    @IBOutlet weak var edtMobileNo: UITextField!
    
    @IBOutlet weak var lblOtpHeader: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblResendOtp: UILabel!
    @IBOutlet weak var lblTermsCondition: UILabel!
    
    @IBOutlet weak var vwOTP: UIView!
    
    weak var cpvTextField: CountryPickerView!
    
    weak var otpButton: UIButton!
    
    @IBOutlet weak var vwOtpMain: SVPinView!
    
    private var presenter: iAuthPresenter!
    private var initialToken: [InitialToken] = []
    private var smsData: [SmsData] = []
    private var refreshToken: [InitialToken] = []
    
    var authPayloadObj : AuthPayloadObj? = nil
    
    var initAccessToken = ""
    var otpCount = 0
    var countryCode = ""
    var countryPhoneCode = ""
    var langCode = ""
    var deviceDetail = ""
    var enteredOtp = ""
    
    weak var countdownTimer: Timer!
    var totalTime = Constant.OTP_TIMER
    var countDownStopped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        vwOTP.isHidden = true
        vwUserInput.isHidden = false
        
        
        let cp = CountryPickerView(frame: CGRect(x: 10, y: 0, width: 100, height: 20))
        edtMobileNo.rightView = cp
        
        edtMobileNo.rightViewMode = .always
        self.cpvTextField = cp
        
        cp.setCountryByName("India")
        cp.setCountryByCode("IN")
        cp.setCountryByPhoneCode("+91")
        
        countryCode = self.cpvTextField.selectedCountry.code
        countryPhoneCode = self.cpvTextField.selectedCountry.phoneCode
        langCode = "EN"
        deviceDetail = "\(UIDevice().type.rawValue) (\(Utility.getDeviceId() ?? ""))"
        
        cpvTextField.delegate = self
        cpvTextField.dataSource = self
        
        let tabTermsGesture = UITapGestureRecognizer(target: self, action: #selector(tabTermsTapped(_:)))
        lblTermsCondition.addGestureRecognizer(tabTermsGesture)
        
        let tabResentGesture = UITapGestureRecognizer(target: self, action: #selector(tapResendOtp(_:)))
        lblResendOtp.addGestureRecognizer(tabResentGesture)
        
        self.configurePinView()
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    @objc func tapResendOtp(_ recognizer:UITapGestureRecognizer) {
        print("tap working",countDownStopped)
        
        if countDownStopped
        {
            lblTimer.text = "01:00"
            totalTime = Constant.OTP_TIMER
            startTimer()
            print("start timer in tapResendOtp")
            generatePayload(isOtpResend: true)
            
            if(authPayloadObj != nil){
                presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
            }
        }
    }
    
    
    func startTimer() {
        print("start timer in core")
        lblResendOtp.textColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
        lblResendOtp.isUserInteractionEnabled = false
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        countDownStopped = false
    }
    
    @objc func updateTime() {
        
        lblTimer.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        totalTime = Constant.OTP_TIMER
        countdownTimer?.invalidate()
        // lblTimer.text = "Resend OTP"
        lblResendOtp.textColor = UIColor.init(named: "blueTextColor") ?? .blue
        lblResendOtp.isUserInteractionEnabled = true
        countDownStopped = true
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @IBAction func clickNextOtp(_ sender: Any) {
        
        if(!Utility.isValidPhone(phoneStr: edtMobileNo.text ?? "")){
            Utility.showMessage(title: "Invalid", msg: "Please enter mobile number")
        }
        else{
            presenter.getInitialToken(callFrom: Constant.INITIAL_TOKEN)
        }
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        clearPin()
        endTimer()
        otpCount = 0
        vwUserInput.isHidden = false
        vwOTP.isHidden = true
    }
    
    
    @IBAction func clickValidate(_ sender: Any) {
        if(enteredOtp.count == 6) {
            generatePayload(isOtpResend: false)
            
            if(authPayloadObj != nil){
                presenter.verifyOtp(payload: authPayloadObj!, initialToken: initAccessToken, callFrom: Constant.VERIFY_OTP)
            }
        }else{
            Utility.showMessage(title: "Invalid", msg: "Enter OTP")
        }
    }
    
    
    
    @objc func tabTermsTapped(_ recognizer:UITapGestureRecognizer) {
        
        guard let url = URL(string: Constant.TERMS_WEB_URL) else {
            Utility.showMessage(title: "Error", msg: "Invalid Url")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    func configurePinView() {
       
        
        vwOtpMain.pinLength = 6
        vwOtpMain.interSpace = 5
        vwOtpMain.textColor = UIColor.black
        vwOtpMain.borderLineColor = UIColor.white
        vwOtpMain.activeBorderLineColor = UIColor.white
        vwOtpMain.borderLineThickness = 0
        vwOtpMain.shouldSecureText = false
        vwOtpMain.allowsWhitespaces = false
        vwOtpMain.style = .none
        vwOtpMain.fieldBackgroundColor = UIColor.gray.withAlphaComponent(0.3)
        vwOtpMain.activeFieldBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        vwOtpMain.fieldCornerRadius = 15
        vwOtpMain.activeFieldCornerRadius = 15
        vwOtpMain.placeholder = ""
        vwOtpMain.becomeFirstResponderAtIndex = 0
        vwOtpMain.font = UIFont.systemFont(ofSize: 14)
        vwOtpMain.keyboardType = .phonePad
        
        vwOtpMain.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        vwOtpMain.didFinishCallback = didFinishEnteringPin(pin:)
        vwOtpMain.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            self.enteredOtp = pin
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    @IBAction func clearPin() {
        vwOtpMain.clearPin()
    }
    
    @IBAction func pastePin() {
        guard let pin = UIPasteboard.general.string else {
            // showAlert(title: "Error", message: "Clipboard is empty")
            return
        }
        vwOtpMain.pastePin(pin: pin)
    }
    
    @IBAction func toggleStyle() {

        var nextStyle = vwOtpMain.style.rawValue + 1
        if nextStyle == 3 { nextStyle = 0 }
        let style = SVPinViewStyle(rawValue: nextStyle)!
        switch style {
        case .none:
            vwOtpMain.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.3)
            vwOtpMain.activeFieldBackgroundColor = UIColor.white.withAlphaComponent(0.5)
            vwOtpMain.fieldCornerRadius = 15
            vwOtpMain.activeFieldCornerRadius = 15
            vwOtpMain.style = style
        case .box:
            vwOtpMain.activeBorderLineThickness = 4
            vwOtpMain.fieldBackgroundColor = UIColor.clear
            vwOtpMain.activeFieldBackgroundColor = UIColor.clear
            vwOtpMain.fieldCornerRadius = 0
            vwOtpMain.activeFieldCornerRadius = 0
            vwOtpMain.style = style
        case .underline:
            vwOtpMain.activeBorderLineThickness = 4
            vwOtpMain.fieldBackgroundColor = UIColor.clear
            vwOtpMain.activeFieldBackgroundColor = UIColor.clear
            vwOtpMain.fieldCornerRadius = 0
            vwOtpMain.activeFieldCornerRadius = 0
            vwOtpMain.style = style
        @unknown default: break
        }
        clearPin()
    }
    
    func didFinishEnteringPin(pin:String) {
        self.enteredOtp = pin
        
        if (Utility.isConnectedToNetwork()) {
            
        }else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
       
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryCode = country.code
        countryPhoneCode = country.phoneCode
    }
    
    //  @objc func clicked_compare(sender: UIButton){
    @objc func selectCountryAction(sender: Any) {
        
        cpvTextField.showCountriesList(from: self)
    }
    
    
    func generatePayload(isOtpResend: Bool) {
        
        if(isOtpResend){
            otpCount = 0
        }
        
        authPayloadObj = AuthPayloadObj(un: "", rcode:textFieldRefCode.text ?? "", dm: deviceDetail, os: Utility.getOSVersion() ?? "", cc: countryPhoneCode, em: textFieldMobileNo.text ?? "", l: "EN", it: true, r: isOtpResend, eot: enteredOtp, s: countryCode, t: otpCount)
        
        print("Auth obj - - - - ",authPayloadObj)
        
    }
    
    
}

extension LoginController : AuthPresentable {
    func willLoadData(callFrom:String) {
        self.view.activityStartAnimating()
    }
    
    func didLoadData(callFrom:String){
        if(callFrom == Constant.INITIAL_TOKEN){
            initialToken = presenter.initialToken
            print("** ** Init Token Response ** ** - - - ",initialToken)
            
            if(initialToken.count > 0){
                initAccessToken = initialToken[0].accessToken ?? ""
                
                generatePayload(isOtpResend: false)
                
                if(authPayloadObj != nil){
                    presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
                }
                
            }else{
                Utility.showMessage(title: "Failed", msg: "Token Error")
            }
        }
        
        if(callFrom == Constant.SEND_SMS){
            
            smsData = presenter.sendSMS
            
            let errorMsg = smsData[0].error ?? ""
            otpCount = smsData[0].t ?? 0
            
            if (errorMsg.isEmpty) {
                
                if (otpCount > 0) {
                    if(countdownTimer == nil){
                        startTimer()
                        print("start timer in SEND_SMS")
                        clearPin()
                        vwUserInput.isHidden = true
                        vwOTP.isHidden = false
                        
                        let mobile = (edtMobileNo.text ?? "").removeWhitespace()
                        if(mobile.isEmpty == false){
                            lblOtpHeader.text = "Enter the OTP sent to \(countryPhoneCode) \(mobile.maskPhoneNumber)"
                        }
                     
                    }
                } else {
                    Utility.showMessage(title: "Failed", msg: "SMS delivery failed..please try again later...")
                }
            } else if (errorMsg.lowercased().elementsEqual(Constant.USER_ALREADY_EXISTS)) {
                
                presenter.refreshToken(phoneNo: edtMobileNo.text ?? "", deviceId: deviceDetail, callFrom: Constant.TOKEN_REFRESH)
                
            } else {
                Utility.showMessage(title: "Error", msg: errorMsg)
            }
            
        }
        
        
        if(callFrom == Constant.VERIFY_OTP){
            
            presenter.refreshToken(phoneNo: edtMobileNo.text ?? "", deviceId: deviceDetail, callFrom: Constant.TOKEN_REFRESH)
        }
        
        
        if(callFrom == Constant.TOKEN_REFRESH){
            refreshToken = presenter.refreshToken
            var token = refreshToken[0].accessToken ?? ""
            var time = refreshToken[0].expiresIn ?? 0 // - - - -  incase if we need to call this in splash
            var mobileNo = edtMobileNo.text ?? ""
            
            UserDefaults.standard.set(token, forKey: "Token")
            UserDefaults.standard.set(mobileNo, forKey: "MobileNumber")
            
            self.openViewControllerBasedOnIdentifier("DashboardViewController", "Home")
            
        }
        self.view.activityStopAnimating()
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
        }
        self.view.activityStopAnimating()
    }
}

extension String {
var maskPhoneNumber: String {
   return String(self.enumerated().map { index, char in
       return [self.count - 1, self.count - 2,self.count - 3,self.count - 4].contains(index) ?
   char : "*"
   })
    }
}
