//
//  AuthInteractor.swift
//  Dummy
//
//  Created by Goldmedal on 10/11/21.
//

import Foundation
protocol AuthInteractable: AnyObject {
    func didFinishFetchingData(list: [Any],callFrom:String)
    func didFailFetchingData(error: CustomError,callFrom:String)
}

protocol iAuthInteractor {
    init(presenter: AuthInteractable)
 
    func getInitialToken(callFrom:String)
    func refreshToken(callFrom:String)
    func sendSms(payload: AuthPayloadObj,token:String,callFrom:String)
    func verifyOtp(payload: AuthPayloadObj,callFrom:String)
 
}

class AuthInteractor: iAuthInteractor {
   
    

   private weak var presenter: AuthInteractable?

    required init(presenter: AuthInteractable) {
        self.presenter = presenter
    }

    func getInitialToken(callFrom:String) {

        RemoteClient.request(of: InitialToken.self, target: ResourceType.initialToken, success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data, callFrom: callFrom)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }
    }
    
    func refreshToken(callFrom:String) {

        RemoteClient.request(of: InitialToken.self, target: ResourceType.refreshToken(phone: "", device: ""), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data, callFrom: callFrom)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }
    }
    
    
    func sendSms(payload: AuthPayloadObj,token:String,callFrom:String) {

        RemoteClient.request(of: SmsData.self, target: ResourceType.sendSMS(payload: payload,token:token), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data, callFrom: callFrom)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }
    }
    
    
    func verifyOtp(payload: AuthPayloadObj,callFrom:String) {

        RemoteClient.request(of: SmsData.self, target: ResourceType.verifyOtp(payload: payload), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data, callFrom: callFrom)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error,callFrom: callFrom)
        }
    }
   
}
