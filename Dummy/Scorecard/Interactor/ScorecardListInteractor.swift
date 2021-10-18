//
//  ScorecardListInteractor.swift
//  Dummy
//
//  Created by Goldmedal on 19/09/21.
//

import Foundation
protocol ScorecardListInteractable: AnyObject {
    func didFinishFetchingData(list: [Any])
    func didFailFetchingData(error: CustomError)
}

protocol iScorecardListInteractor {
    init(presenter: ScorecardListInteractable)
    
    func getScorecard(mid:Int)
    func getMatchInfo(mid:Int)

}

class ScorecardListInteractor: iScorecardListInteractor {
   
   private weak var presenter: ScorecardListInteractable?

    required init(presenter: ScorecardListInteractable) {
        self.presenter = presenter
    }

    
    func getScorecard(mid:Int) {

        RemoteClient.request(of: ScorecardMain.self, target: ResourceType.getMatchScoreCard(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error)
        }
    }

    func getMatchInfo(mid: Int) {
        RemoteClient.request(of: MatchData.self, target: ResourceType.aboutMatch(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingData(list: data)
            case .failure(let error):
                ws.presenter?.didFailFetchingData(error: error)
            }
            }, error: { [weak self] error in
                guard let ws = self else {return}
                ws.presenter?.didFailFetchingData(error: error)
        }) {  [weak self]error in
            guard let ws = self else {return}
            ws.presenter?.didFailFetchingData(error: error)
        }
    }
    

   
}

