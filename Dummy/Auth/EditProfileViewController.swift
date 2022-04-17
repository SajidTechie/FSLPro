//
//  EditProfileViewController.swift
//  Dummy
//
//  Created by Goldmedal on 19/03/22.
//

import UIKit
import Foundation



struct ProfileObj:Codable{
    let DN : String?
    let FN : String?
    let LN : String?
    let mail : String?
    let MN : String?
    let gender : String?
    let dob : String?
    let addr : String?
    let city : String?
    let state : String?
    let pin : String?
    let country : String?
    
    init(DN: String, FN: String, LN: String, mail: String, gender: String, mob: String, dob: String, addr: String, city: String, state: String, pin: String, country: String) {
           self.DN = DN
           self.FN = FN
           self.LN = LN
           self.mail = mail
           self.MN = mob
           self.gender = gender
           self.dob = dob
           self.addr = addr
           self.city = city
           self.state = state
           self.pin = pin
           self.country = country
       }
}

class EditProfileViewController: UIViewController,CommonDelegate {
    @IBOutlet weak var header : Header!
    @IBOutlet weak var edtUserName : UITextField!
    @IBOutlet weak var edtFN : UITextField!
    @IBOutlet weak var edtLN : UITextField!
    @IBOutlet weak var lblDOB : UILabel!
    @IBOutlet weak var lblGender : UILabel!
    @IBOutlet weak var edtEmail : UITextField!
    @IBOutlet weak var edtMobileNo : UITextField!
    @IBOutlet weak var lblCountry : UILabel!
    @IBOutlet weak var lblState : UILabel!
    @IBOutlet weak var lblCity : UILabel!
    @IBOutlet weak var edtPincode : UITextField!
    @IBOutlet weak var multiLineAddress : UITextView!
    
    var dateFormatter = DateFormatter()
    var dobDate: Date?
    let MIN_ZIP_CODE_LENGTH = 6
    var strDOB = ""
    var strGender = ""
    
    private var presenter: iAuthPresenter!
    private var userProfile: [UserProfileData] = []
    private var sendProfileObj : ProfileObj?
    private var pincodeArray: [PincodeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        header.delegate = self
        header.bindData(strTitle: "EDIT INFORMATION")
        
        attachListeners()
        
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        presenter.getUserProfile(callFrom: Constant.USER_PROFILE)
        
        disableView(view: self.lblCity)
        disableView(view: self.lblCountry)
        disableView(view: self.lblState)
        
    }
    
    func attachListeners(){
        
        let tapGenderGesture = UITapGestureRecognizer(target: self, action: #selector(genderTapped(_:)))
        self.lblGender.addGestureRecognizer(tapGenderGesture)
        
        let tapCityGesture = UITapGestureRecognizer(target: self, action: #selector(cityTapped(_:)))
        lblCity.addGestureRecognizer(tapCityGesture)
        
        let tapDOBGesture = UITapGestureRecognizer(target: self, action: #selector(dobTapped(_:)))
        lblDOB.addGestureRecognizer(tapDOBGesture)
        
        self.edtPincode.addTarget(self, action: #selector(self.searchPincode(_ :)), for: .editingChanged)
    }
    
    
    
    func bindUserProfile(user: UserProfileData?){
        self.edtUserName.text = user?.dN ?? "-"
        self.edtFN.text = user?.fN ?? "-"
        self.edtLN.text = user?.lN ?? "-"
     
        switch (user?.gender ?? "-") {
        case "M":
                strGender = "MALE"
                break
            
        case "F":
                strGender = "FEMALE"
                break
            
        case "T":
                strGender = "TRANSGENDER"
                break
            
        case "O":
                strGender = "OTHERS"
                break
            
        default:
            break
        }
        
        strDOB = Utility.formattedDateWithOtherFormat(dateString: user?.dob ?? "-", givenFormat: "yyyy-MM-dd'T'HH:mm:ss", withFormat: "dd-MMM-yyyy") ?? "-"
    
        self.lblDOB.text = strDOB
        self.lblGender.text = strGender
        self.edtEmail.text = user?.mail ?? "-"
        self.edtMobileNo.text = user?.mob ?? "-"
        self.lblCountry.text = user?.country ?? "-"
        self.lblState.text = user?.state ?? "-"
        self.lblCity.text = user?.city ?? "-"
        self.edtPincode.text = user?.pin ?? "-"
        self.multiLineAddress.text = user?.addr ?? "-"
    }
    
    func bindCountryState(){
        if(pincodeArray.count > 0){
            self.lblCountry.text = pincodeArray[0].country ?? "-"
            self.lblState.text = pincodeArray[0].state ?? "-"
            
        }
    }
    
    func enableView(view: UIView){
        view.isUserInteractionEnabled = true
        view.alpha = 1
    }
    
    func disableView(view: UIView){
        view.isUserInteractionEnabled = false
        view.alpha = 0.3
    }
    
    @objc func genderTapped(_ recognizer:UITapGestureRecognizer) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vcGenderPopup = storyBoard.instantiateViewController(withIdentifier: "SelectProfilePopupController") as! SelectProfilePopupController
        vcGenderPopup.strTitle = "SELECT GENDER"
        vcGenderPopup.fromPage = "gender"
        vcGenderPopup.delegate = self
        self.present(vcGenderPopup, animated: false)
    }
    
    @objc func dobTapped(_ recognizer:UITapGestureRecognizer) {
        
        let sb = UIStoryboard(name: "DatePicker", bundle: nil)
        
        let popup = sb.instantiateInitialViewController()  as? DatePickerController
        popup?.callFrom = "DOB"
        
        let currDate = Date()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        var strFromDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: -1, to: currDate)!)
        var fromDate = dateFormatter.date(from: strFromDate)
        popup?.fromDate = fromDate
        
        popup?.delegate = self
        self.present(popup!, animated: false)
    }
    
    func updateDate(value: String, date: Date) {
        strDOB = value
        lblDOB.text = strDOB
    }
    
    @objc func cityTapped(_ recognizer:UITapGestureRecognizer) {
        
        if(pincodeArray.count > 0){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcCity = storyBoard.instantiateViewController(withIdentifier: "SelectProfilePopupController") as! SelectProfilePopupController
            vcCity.strTitle = "SELECT CITY"
            vcCity.fromPage = "city"
            vcCity.pincodeArray = self.pincodeArray
            vcCity.delegate = self
            self.present(vcCity, animated: false)
        }else{
            Utility.showMessage(title: "", msg: "Please enter pincode first")
        }
    }
    
    //Auto-Complete Function...
    @objc func searchPincode(_ textfield: UITextField){
        
        self.pincodeArray.removeAll()
        if edtPincode.text?.count ?? 0 >= MIN_ZIP_CODE_LENGTH {
            presenter.getPincode(pincode: Int(edtPincode.text ?? "0") ?? 0, callFrom: Constant.PINCODE)
            enableView(view: self.lblCity)
        }else{
            disableView(view: self.lblCity)
        }
        
    }
}

extension EditProfileViewController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: false)
    }
}



extension EditProfileViewController : AuthPresentable {
    func willLoadData(callFrom:String) {
        self.view.activityStartAnimating()
    }
    
    func didLoadData(callFrom:String){
        if(callFrom == Constant.USER_PROFILE){
            
            
            userProfile = presenter.getUserProfile
            print("** ** User Profile Response ** ** - - - ",userProfile)
            
            if(userProfile.count > 0){
                bindUserProfile(user: userProfile[0])
            }
        }
        
        if(callFrom == Constant.PINCODE){
            
            pincodeArray = presenter.getPincode
            bindCountryState()
            enableView(view: self.lblCity)
        }
        
        
        if(callFrom == Constant.EDIT_PROFILE){
            presenter.getUserProfile(callFrom: Constant.USER_PROFILE)
            Utility.showMessage(title: "Success", msg: "Profile Updated Successfully!!")
        }
        
        
        if(callFrom == Constant.TOKEN_REFRESH){
            //            refreshToken = presenter.refreshToken
            //            var token = refreshToken[0].accessToken ?? ""
            //            var time = refreshToken[0].expiresIn ?? 0 // - - - -  incase if we need to call this in splash
            //            var mobileNo = edtMobileNo.text ?? ""
            //
            //            UserDefaults.standard.set(token, forKey: "Token")
            //            UserDefaults.standard.set(mobileNo, forKey: "MobileNumber")
         
        }
        
        self.view.activityStopAnimating()
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        //        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
        //            print("TOKEN ERROR")
        //            //Refresh API
        //            presenter.sendSMS(payload: authPayloadObj!, token: initAccessToken, callFrom: Constant.SEND_SMS)
        //        }
        self.view.activityStopAnimating()
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        if((edtUserName.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter username")
            return
        }
        
        if((edtFN.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter first name")
            return
        }
        
        if((edtLN.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter last name")
            return
        }
        
        if((strDOB.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Select date of birth")
            return
        }
        
        if((strGender.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Select Gender")
            return
        }
        
        if((edtEmail.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter Email")
            return
        }
        
        if((edtPincode.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter Pincode")
            return
        }
        
        if((lblCity.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Select City")
            return
        }
        
        if((lblCountry.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter Valid Pincode")
            return
        }
        
        if((lblState.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter Valid Pincode")
            return
        }
        
        if((multiLineAddress.text?.removeWhitespace().isEmpty) == true){
            Utility.showMessage(title: "", msg: "Enter Address")
            return
        }
        
        sendProfileObj = ProfileObj(DN: edtUserName.text ?? "", FN: edtFN.text ?? "", LN: edtLN.text ?? "", mail: edtEmail.text ?? "", gender: strGender, mob: "", dob: strDOB, addr: multiLineAddress.text ?? "", city: lblCity.text ?? "", state: lblState.text ?? "", pin: edtPincode.text ?? "", country: lblCountry.text ?? "")
   
        print("Object Profile - - - - ",sendProfileObj)
        
        if(sendProfileObj != nil)
       { presenter.editUserProfile(payload: sendProfileObj!, callFrom: Constant.EDIT_PROFILE)}
  
    }
}


extension EditProfileViewController : CellSelectionDelegate{
    
    func cellSelected(model: Any?) {
        
        switch model {
        case let item as GenderData:
            strGender = item.genderName ?? ""
            lblGender.text = strGender
            
        case let item as PincodeData?:
            self.lblCity.text = item?.city ?? "-"
            self.lblCountry.text = item?.country ?? "-"
            self.lblState.text = item?.state ?? "-"
        default:
            print("something else")
        }
        
    }
}


extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: "-", replacement: "").replace(string: " ", replacement: "")
    }
  }
