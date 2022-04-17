//
//  AuthPresenter.swift
//  Dummy
//
//  Created by Goldmedal on 10/11/21.
//

import Foundation
protocol AuthPresentable: Presentable {
    
}

protocol iAuthPresenter: iPresenter {
    var view: AuthPresentable? {get set}
    
    func getInitialToken(callFrom:String)
    var initialToken: [InitialToken] {get set}
    
    func getInitialData(callFrom:String)
    var initialData: [InitialData] {get set}
    
    func refreshToken(phoneNo:String,deviceId:String,callFrom:String)
    var refreshToken: [InitialToken] {get set}
    
    func sendSMS(payload: AuthPayloadObj,token:String,callFrom:String)
    var sendSMS: [SmsData] {get set}
    
    func verifyOtp(payload: AuthPayloadObj,initialToken:String,callFrom:String)
    var verifyOtp: [SmsData] {get set}
    
    func getUserProfile(callFrom:String)
    var getUserProfile: [UserProfileData] {get set}
    
    func editUserProfile(payload: ProfileObj,callFrom:String)
    var editUserProfile: [UserProfileData] {get set}
    
    func getPincode(pincode:Int,callFrom:String)
    var getPincode: [PincodeData] {get set}

}

class AuthPresenter: iAuthPresenter {
   
    var initialData: [InitialData] = []
    var initialToken: [InitialToken] = []
    var refreshToken: [InitialToken] = []
    var sendSMS: [SmsData] = []
    var verifyOtp: [SmsData] = []
     var getUserProfile: [UserProfileData] = []
    var editUserProfile: [UserProfileData] = []
    var getPincode: [PincodeData] = []
    
    weak var view: AuthPresentable?
    var interactor: iAuthInteractor!
    
    required init(view: Presentable) {
        self.view = view as? AuthPresentable
    }
    
    func initInteractor() {
        interactor = AuthInteractor(presenter: self)
    }
    
    
    
    func getInitialData(callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
 
            do {
                try interactor.getInitialApi(callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
      
    }
    
    func getInitialToken(callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
 
            do {
                try interactor.getInitialToken(callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
      
    }
 
    
    func refreshToken(phoneNo:String,deviceId:String,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
    
            do {
                try interactor.refreshToken(phoneNo:phoneNo,deviceId:deviceId,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
    
    }
    
    
    func sendSMS(payload: AuthPayloadObj,token:String, callFrom: String)  {
        view?.willLoadData(callFrom:callFrom)
    
            do {
                try interactor.sendSms(payload: payload,token:token, callFrom: callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
 
    
    func verifyOtp(payload: AuthPayloadObj,initialToken:String,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
     
            do {
                try interactor.verifyOtp(payload: payload,initialToken:initialToken,callFrom: callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
     
    }

    
    func getUserProfile(callFrom:String)  {
           view?.willLoadData(callFrom:callFrom)
        
               do {
                   try interactor.getUserProfile(callFrom: callFrom)
               }
               catch
                   CustomError.DatabaseError {
                   view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                       
               }
               catch let err {
                   view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
               }
        
       }
    
    
    func editUserProfile(payload: ProfileObj,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
     
            do {
                try interactor.editUserProfile(payload: payload,callFrom: callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
     
    }
    
    func getPincode(pincode:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
     
            do {
                try interactor.getPincode(pincode: pincode,callFrom: callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
     
    }
}


extension AuthPresenter: AuthInteractable {
  
    func didFinishFetchingData(list: [Any],callFrom:String) {
        initialData = list as? [InitialData] ?? []
        initialToken = list as? [InitialToken] ?? []
        refreshToken = list as? [InitialToken] ?? []
        sendSMS = list as? [SmsData] ?? []
        verifyOtp = list as? [SmsData] ?? []
        getUserProfile = list as? [UserProfileData] ?? []
        editUserProfile = list as? [UserProfileData] ?? []
        getPincode = list as? [PincodeData] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
   
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
