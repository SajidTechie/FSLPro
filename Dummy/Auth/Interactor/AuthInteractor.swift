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
 
}

class AuthInteractor: iAuthInteractor {

   private weak var presenter: AuthInteractable?

    required init(presenter: AuthInteractable) {
        self.presenter = presenter
    }

    func getInitialToken(callFrom:String) {

        RemoteClient.request(of: Match.self, target: ResourceType.initialToken, success: { [weak self] result in
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
