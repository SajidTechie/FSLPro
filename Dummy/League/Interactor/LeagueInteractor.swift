//
//  CountryListInteractor.swift
//  DigitasWorld
//
//  Created by ashok on 02/09/20.
//  Copyright © 2020 eSoft Technologies. All rights reserved.
//

import Foundation

protocol LeagueInteractable: AnyObject {
    func didFinishFetchingData(list: [Any])
    func didFailFetchingData(error: CustomError)
}

protocol iLeagueInteractor {
    init(presenter: LeagueInteractable)
   
    func leagueForMatch(mid:Int)
    func getMyTeam(mid:Int)
    func joinLeague(mid: Int,lid: Int,teamid: Int)
    func getMyJoinedLeagues(mid:Int)
    func getMyJoinedLeagueDetail(mid: Int,lid: Int)
}

class LeagueInteractor: iLeagueInteractor {

   private weak var presenter: LeagueInteractable?

    required init(presenter: LeagueInteractable) {
        self.presenter = presenter
    }

    func leagueForMatch(mid:Int) {

        RemoteClient.request(of: LeagueDetailData.self, target: ResourceType.getLeaguesForMatch(mid: mid), success: { [weak self] result in
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
    
    
    func getMyJoinedLeagues(mid:Int) {

        RemoteClient.request(of: MyJoinedLeagueData.self, target: ResourceType.getMyJoinedLeagues(mid: mid), success: { [weak self] result in
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
    
    func joinLeague(mid: Int,lid: Int,teamid: Int) {

        RemoteClient.request(of: JoinedLeagueData.self, target: ResourceType.joinLeague(mid: mid, lid: lid, teamid: teamid), success: { [weak self] result in
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
    
    func getMyTeam(mid: Int) {

        RemoteClient.request(of: MyTeamNameData.self, target: ResourceType.myTeam(mid: mid), success: { [weak self] result in
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
    
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int) {

        RemoteClient.request(of: LeagueDetailData.self, target: ResourceType.getMyJoinedLeaguesDetail(mid: mid, lid: lid), success: { [weak self] result in
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


