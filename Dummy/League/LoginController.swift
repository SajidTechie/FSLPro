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
    var dm: String
    var os: String
    var cc: String
    var em: String
    var l: String
    var it: Bool
    var r: Bool
    var eot: String
    var s: String
   var t: Int = -1
    
    init(un:String,dm:String,os:String,cc:String,em:String,l:String,it:Bool,r:Bool,eot:String,s:String,t:Int) //,?
    {
        self.un = un
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
    
    //    init(un:String,dm:String,os:String,cc:String,em:String,l:String,it:Bool,r:Bool,eot:String,s:String)
    //    {
    //        self.un = un
    //        self.dm = dm
    //        self.os = os
    //        self.cc = cc
    //        self.em = em
    //        self.l = l
    //        self.it = it
    //        self.r = r
    //        self.eot = eot
    //        self.s = s
    //    }
}


class LoginController: UIViewController ,CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMobileNo: UITextField!
    
    @IBOutlet weak var vwSelectCountry: UIView!
    @IBOutlet weak var vwUserInput: UIView!
    @IBOutlet weak var edtMobileNo: UITextField!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var btnTermsNCondition: UIButton!
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
    
    var countdownTimer: Timer!
    var totalTime = 10
    var countDownStopped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        btnTermsNCondition.isSelected = true
        vwOTP.isHidden = true
        vwUserInput.isHidden = false
        
        let cp = CountryPickerView(frame: CGRect(x: 10, y: 0, width: 110, height: 20))
        edtMobileNo.leftView = cp
        
        edtMobileNo.leftViewMode = .always
        self.cpvTextField = cp
        
        countryCode = self.cpvTextField.selectedCountry.code
        countryPhoneCode = self.cpvTextField.selectedCountry.phoneCode
        langCode = "EN"
        deviceDetail = "\(UIDevice().type.rawValue) (\(Utility.getDeviceId() ?? ""))"
        
        
        let otpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 25))
        otpButton.setTitle("OTP", for: .normal)
        otpButton.backgroundColor = UIColor.red
        
        edtMobileNo.rightView = otpButton
        
        edtMobileNo.rightViewMode = .always
        self.otpButton = otpButton
        
        self.otpButton.addTarget(self, action: #selector(clickedOtp), for: .touchUpInside)
        
        cpvTextField.delegate = self
        cpvTextField.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectCountryAction(sender:)))
        cpvTextField.addGestureRecognizer(tapGesture)
        
        let resendOtp = UITapGestureRecognizer(target: self, action: #selector(self.tapResendOtp))
        lblTimer.addGestureRecognizer(resendOtp)
        
        self.configurePinView()
    }
    
    
    
    @objc func tapResendOtp(sender:UITapGestureRecognizer) {
        print("tap working",countDownStopped)
        
        if countDownStopped
        {
            lblTimer.text = "05:00"
            totalTime = 300
            startTimer()
            
            generatePayload(isOtpResend: true, retryCount: -1)
            
            if(authPayloadObj != nil){
                presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
            }
        }
    }
    
    func startTimer() {
        lblTimer.textColor = UIColor.black
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
        countdownTimer.invalidate()
        lblTimer.text = "Resend OTP"
        countDownStopped = true
        if #available(iOS 11.0, *) {
            lblTimer.textColor = UIColor.init(named: "ColorRed")
        } else {
           lblTimer.textColor = UIColor.red
        }
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
    @objc func clickedOtp() {
        if(!Utility.isValidPhone(phoneStr: edtMobileNo.text ?? "")){
            Utility.showMessage(title: "Invalid", msg: "Please enter mobile number")
        }else if(btnTermsNCondition.isSelected){
            presenter.getInitialToken(callFrom: Constant.INITIAL_TOKEN)
        }else{
            Utility.showMessage(title: "Invalid", msg: "Please check terms and conditions box to proceed")
        }
        
    }
    
    
    func configurePinView() {
        
        vwOtpMain.pinLength = 6
        vwOtpMain.interSpace = 5
        vwOtpMain.textColor = UIColor.white
        //               vwOtpMain.borderLineColor = UIColor.white
        //               vwOtpMain.activeBorderLineColor = UIColor.white
        vwOtpMain.borderLineThickness = 1
        vwOtpMain.shouldSecureText = false
        vwOtpMain.allowsWhitespaces = false
        vwOtpMain.style = .none
        //   vwOtpMain.fieldBackgroundColor = UIColor.gray.withAlphaComponent(0.3)
        //   vwOtpMain.activeFieldBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        vwOtpMain.fieldCornerRadius = 0
        vwOtpMain.activeFieldCornerRadius = 0
        vwOtpMain.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        vwOtpMain.keyboardAppearance = .default
        vwOtpMain.tintColor = .white
        vwOtpMain.becomeFirstResponderAtIndex = 0
        vwOtpMain.shouldDismissKeyboardOnEmptyFirstField = false
        
        vwOtpMain.font = UIFont.systemFont(ofSize: 15)
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
        if nextStyle == 3 {nextStyle = 0}
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
        }
        clearPin()
    }
    
    func didFinishEnteringPin(pin:String) {
        self.enteredOtp = pin
        
        if (Utility.isConnectedToNetwork()) {
            
        }else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //                exit(0)
            //            }
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
    
    
    func generatePayload(isOtpResend: Bool, retryCount: Int?) {
        
        
        authPayloadObj = AuthPayloadObj(un: textFieldUserName.text ?? "", dm: deviceDetail, os: Utility.getOSVersion() ?? "", cc: countryPhoneCode, em: textFieldMobileNo.text ?? "", l: "EN", it: true, r: isOtpResend, eot: enteredOtp, s: countryCode, t: otpCount)// Retry count //
        
        print("Auth obj - - - - ",authPayloadObj)
        
    }
    
    
    @IBAction func clicked_terms(_ sender: UIButton) {
        if(!btnTermsNCondition.isSelected)
        {
            btnTermsNCondition.isSelected = true
        }else{
            btnTermsNCondition.isSelected = false
        }
    }
    
    
    @IBAction func validate_otp(_ sender: UIButton) {
        if(enteredOtp.count == 6) {
            generatePayload(isOtpResend: false, retryCount: otpCount)
            
            if(authPayloadObj != nil){
                presenter.verifyOtp(payload: authPayloadObj!, initialToken: initAccessToken, callFrom: Constant.VERIFY_OTP)
            }
        }else{
            Utility.showMessage(title: "Invalid", msg: "Enter OTP")
        }
        
    }
    
    
    
}

extension LoginController : AuthPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        if(callFrom == Constant.INITIAL_TOKEN){
            initialToken = presenter.initialToken
            print("** ** Init Token Response ** ** - - - ",initialToken)
            
            if(initialToken.count > 0){
                initAccessToken = initialToken[0].accessToken ?? ""
                
                generatePayload(isOtpResend: false, retryCount: -1)
                
                if(authPayloadObj != nil){
                    presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
                }
                
            }
        }
        
        if(callFrom == Constant.SEND_SMS){
            
            smsData = presenter.sendSMS
            
            let errorMsg = smsData[0].error ?? ""
            otpCount = smsData[0].t ?? 0
            
            if (errorMsg.isEmpty) {
                
                if (otpCount > 0) {
                     startTimer()
                    vwUserInput.isHidden = true
                    vwOTP.isHidden = false
                    //                               binding.txtMaskedMobileNo.text = "${resources.getString(R.string.verification_code_subtext)} ${binding.ccp.selectedCountryCodeWithPlus}${getLoginMobileNo().replace("[^0-9]".toRegex(), "").replace(MASK_MOBILE_NO_REGEX.toRegex(), "*")}"
                    //
                    //                               binding.otpView.requestFocus()
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
            
            
         
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false, completion: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let vcDashboard = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                
                let navVc = UINavigationController(rootViewController: vcDashboard)
                pvc?.present(navVc, animated: false, completion: nil)
            })
      
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


