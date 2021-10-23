//
//  CountryListInteractor.swift
//  DigitasWorld
//
//  Created by ashok on 02/09/20.
//  Copyright © 2020 eSoft Technologies. All rights reserved.
//

import Foundation

protocol MatchesInteractable: AnyObject {
    func didFinishFetchingData(list: [Any],callFrom:String)
    func didFinishFetchingDataWithPosition(list: [Any],position:Int,callFrom:String)
    func didFailFetchingData(error: CustomError,callFrom:String)
}

protocol iMatchesInteractor {
    init(presenter: MatchesInteractable)
   
    func fetchAllMatches(mid:Int,callFrom:String)
    func fetchAllLiveMatches(mid:Int,position:Int,callFrom:String)
    func fetchLiveScore(mid:Int,position:Int,callFrom:String)
    func getMatchRules(callFrom:String)
}

class MatchesInteractor: iMatchesInteractor {

   private weak var presenter: MatchesInteractable?

    required init(presenter: MatchesInteractable) {
        self.presenter = presenter
    }

    func fetchAllMatches(mid:Int,callFrom:String) {

        RemoteClient.request(of: Match.self, target: ResourceType.matches(mid: mid), success: { [weak self] result in
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
    
    
    func fetchAllLiveMatches(mid:Int,position:Int,callFrom:String) {

        RemoteClient.request(of: Match.self, target: ResourceType.matches(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingDataWithPosition(list: data,position:position,callFrom:callFrom)
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
    
    func fetchLiveScore(mid:Int,position:Int,callFrom:String) {

        RemoteClient.request(of: LiveScoreData.self, target: ResourceType.getLiveScore(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingDataWithPosition(list: data,position:position,callFrom:callFrom)
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
    
    func getMatchRules(callFrom:String) {

        RemoteClient.request(of: GetRulesData.self, target: ResourceType.getMatchRules, success: { [weak self] result in
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
