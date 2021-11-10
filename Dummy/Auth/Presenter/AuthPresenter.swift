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
    
    func getToken(mid:Int,callFrom:String)
    var myTeamRank: [TeamRankData] {get set}

}

class AuthPresenter: iAuthPresenter {
   
    var myTeamRank: [TeamRankData] = []
    
    weak var view: AuthPresentable?
    var interactor: iAuthInteractor!
    
    required init(view: Presentable) {
        self.view = view as? AuthPresentable
    }
    
    func initInteractor() {
        interactor = AuthInteractor(presenter: self)
    }
    
    
    func getToken(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.fetchAllAuth(mid: mid,callFrom:callFrom)
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
        myTeamRank = list as? [TeamRankData] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
   
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
