//
//  CountryListInteractor.swift
//  DigitasWorld
//
//  Created by ashok on 02/09/20.
//  Copyright © 2020 eSoft Technologies. All rights reserved.
//

import Foundation

protocol MatchesInteractable: AnyObject {
    func didFinishFetchingData(list: [Any])
    func didFinishFetchingDataWithPosition(list: [Any],position:Int)
    func didFailFetchingData(error: CustomError)
}

protocol iMatchesInteractor {
    init(presenter: MatchesInteractable)
   
    func fetchAllMatches(mid:Int)
    func fetchAllLiveMatches(mid:Int,position:Int)
    func fetchLiveScore(mid:Int,position:Int)
    func getMatchRules()
}

class MatchesInteractor: iMatchesInteractor {

   private weak var presenter: MatchesInteractable?

    required init(presenter: MatchesInteractable) {
        self.presenter = presenter
    }

    func fetchAllMatches(mid:Int) {

        RemoteClient.request(of: Match.self, target: ResourceType.matches(mid: mid), success: { [weak self] result in
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
    
    
    func fetchAllLiveMatches(mid:Int,position:Int) {

        RemoteClient.request(of: Match.self, target: ResourceType.matches(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingDataWithPosition(list: data,position:position)
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
    
    func fetchLiveScore(mid:Int,position:Int) {

        RemoteClient.request(of: LiveScoreData.self, target: ResourceType.getLiveScore(mid: mid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
                ws.presenter?.didFinishFetchingDataWithPosition(list: data,position:position)
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
    
    func getMatchRules() {

        RemoteClient.request(of: GetRulesData.self, target: ResourceType.getMatchRules, success: { [weak self] result in
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
