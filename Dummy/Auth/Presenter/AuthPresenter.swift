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

}

class AuthPresenter: iAuthPresenter {
   
    var initialToken: [InitialToken] = []
    
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
 

}


extension AuthPresenter: AuthInteractable {
  
    func didFinishFetchingData(list: [Any],callFrom:String) {
        initialToken = list as? [InitialToken] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
   
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
