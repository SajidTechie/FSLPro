//
//  ScorecardListInteractor.swift
//  Dummy
//
//  Created by Goldmedal on 19/09/21.
//

import Foundation
protocol ScorecardListInteractable: AnyObject {
    func didFinishFetchingData(list: [Any],callFrom:String)
    func didFailFetchingData(error: CustomError,callFrom:String)
}

protocol iScorecardListInteractor {
    init(presenter: ScorecardListInteractable)
    
    func getScorecard(mid:Int,callFrom:String)
    func getMatchInfo(mid:Int,callFrom:String)
    func getLeaderboardData(mid:Int,lid:Int,callFrom:String)
}

class ScorecardListInteractor: iScorecardListInteractor {
   
   private weak var presenter: ScorecardListInteractable?

    required init(presenter: ScorecardListInteractable) {
        self.presenter = presenter
    }

    
    func getScorecard(mid:Int,callFrom:String) {

        RemoteClient.request(of: ScorecardMain.self, target: ResourceType.getMatchScoreCard(mid: mid), success: { [weak self] result in
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

    func getMatchInfo(mid: Int,callFrom:String) {
        RemoteClient.request(of: MatchData.self, target: ResourceType.aboutMatch(mid: mid), success: { [weak self] result in
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
    
    func getLeaderboardData(mid: Int,lid:Int,callFrom:String) {
        RemoteClient.request(of: LeaderboardData.self, target: ResourceType.getLeaderBoard(mid: mid, lid: lid), success: { [weak self] result in
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

