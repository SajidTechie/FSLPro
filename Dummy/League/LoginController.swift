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
    var t: Int
    
    init(un:String,dm:String,os:String,cc:String,em:String,l:String,it:Bool,r:Bool,eot:String,s:String,t:Int?)
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
        self.t = t ?? 0
    }
}


class LoginController: UIViewController ,CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMobileNo: UITextField!
    
    @IBOutlet weak var vwSelectCountry: UIView!
    @IBOutlet weak var edtMobileNo: UITextField!
    weak var cpvTextField: CountryPickerView!
    
    weak var otpButton: UIButton!
    
    @IBOutlet weak var vwOtpMain: SVPinView!
    
    private var presenter: iAuthPresenter!
    private var initialToken: [InitialToken] = []
    
    var authPayloadObj : AuthPayloadObj? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        
        let cp = CountryPickerView(frame: CGRect(x: 10, y: 0, width: 110, height: 20))
        edtMobileNo.leftView = cp
    
        edtMobileNo.leftViewMode = .always
        self.cpvTextField = cp
        
        
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
        
        self.configurePinView()
    }
    
    
    @objc func clickedOtp() {
        presenter.getInitialToken(callFrom: Constant.INITIAL_TOKEN)
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
        //    self.mpin = pin
        //   showAlert(title: "Success", message: "The Pin entered is \(pin)")
        if (Utility.isConnectedToNetwork()) {
            //    self.apiCheckMpin()
        }else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                exit(0)
            }
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
    }
    
    //  @objc func clicked_compare(sender: UIButton){
    @objc func selectCountryAction(sender: Any) {
        
        cpvTextField.showCountriesList(from: self)
    }
    
    
    func generatePayload(isOtpResend: Bool, retryCount: Int?) {
        
        
        authPayloadObj = AuthPayloadObj(un: textFieldUserName.text ?? "", dm: "device model", os: "OS VER", cc: "Country Code", em: textFieldMobileNo.text ?? "", l: "lang code", it: true, r: isOtpResend, eot: "OTP", s: "Country Code", t: retryCount)// Retry count
        
        print("Auth obj - - - - ",authPayloadObj)
        
        
    }
   
}

extension LoginController : AuthPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        initialToken = presenter.initialToken
        print("** ** Init Token Response ** ** - - - ",initialToken)
        
      
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


