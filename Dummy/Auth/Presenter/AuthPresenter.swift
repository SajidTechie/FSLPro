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
    
    func refreshToken(callFrom:String)
    var refreshToken: [InitialToken] {get set}
    
    func sendSMS(payload: AuthPayloadObj,token:String,callFrom:String)
    var sendSMS: [SmsData] {get set}
    
    func verifyOtp(payload: AuthPayloadObj,callFrom:String)
    var verifyOtp: [SmsData] {get set}

}

class AuthPresenter: iAuthPresenter {
  
   
    var initialToken: [InitialToken] = []
    var refreshToken: [InitialToken] = []
    var sendSMS: [SmsData] = []
    var verifyOtp: [SmsData] = []
    
    weak var view: AuthPresentable?
    var interactor: iAuthInteractor!
    
    required init(view: Presentable) {
        self.view = view as? AuthPresentable
    }
    
    func initInteractor() {
        interactor = AuthInteractor(presenter: self)
    }
    
    
    func getInitialToken(callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
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
     
    }
 
    
    func refreshToken(callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.refreshToken(callFrom:callFrom)
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
    
    
    func sendSMS(payload: AuthPayloadObj,token:String, callFrom: String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
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
     
    }
    
 
    
    func verifyOtp(payload: AuthPayloadObj,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.verifyOtp(payload: payload,callFrom: callFrom)
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

}


extension AuthPresenter: AuthInteractable {
  
    func didFinishFetchingData(list: [Any],callFrom:String) {
        initialToken = list as? [InitialToken] ?? []
        refreshToken = list as? [InitialToken] ?? []
        sendSMS = list as? [SmsData] ?? []
        verifyOtp = list as? [SmsData] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
   
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
