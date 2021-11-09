//
//  CountryListInteractor.swift
//  DigitasWorld
//
//  Created by ashok on 02/09/20.
//  Copyright © 2020 eSoft Technologies. All rights reserved.
//

import Foundation

protocol LeagueInteractable: AnyObject {
    func didFinishFetchingData(list: [Any],callFrom:String)
    func didFailFetchingData(error: CustomError,callFrom:String)
    func didFinishFetchingDataWithPosition(list: [Any],position:Int,callFrom:String)
}

protocol iLeagueInteractor {
    init(presenter: LeagueInteractable)
   
    func getLeagueEntryDetail(mid: Int,lid: Int,callFrom:String)
    func leagueForMatch(mid:Int,callFrom:String)
    func getMyTeam(mid:Int,callFrom:String)
    func joinLeague(mid: Int,lid: Int,teamid: Int,callFrom:String)
    func getMyJoinedLeagues(mid:Int,callFrom:String)
    func getMyJoinedLeagueDetail(mid: Int,lid: Int,position:Int,callFrom:String)
}

class LeagueInteractor: iLeagueInteractor {
    

   private weak var presenter: LeagueInteractable?

    required init(presenter: LeagueInteractable) {
        self.presenter = presenter
    }

    func leagueForMatch(mid:Int,callFrom:String) {

        RemoteClient.request(of: LeagueDetailData.self, target: ResourceType.getLeaguesForMatch(mid: mid), success: { [weak self] result in
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
    
    
    func getMyJoinedLeagues(mid:Int,callFrom:String) {

        RemoteClient.request(of: MyJoinedLeagueData.self, target: ResourceType.getMyJoinedLeagues(mid: mid), success: { [weak self] result in
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
    
    func joinLeague(mid: Int,lid: Int,teamid: Int,callFrom:String) {

        RemoteClient.request(of: JoinedLeagueData.self, target: ResourceType.joinLeague(mid: mid, lid: lid, teamid: teamid), success: { [weak self] result in
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
    
    
    func getLeagueEntryDetail(mid: Int,lid: Int,callFrom:String) {

        RemoteClient.request(of: LeagueEntryDetailsData.self, target: ResourceType.getLeagueEntryDetails(mid: mid, lid: lid), success: { [weak self] result in
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
    
    
    func getMyTeam(mid: Int,callFrom:String) {

        RemoteClient.request(of: MyTeamNameData.self, target: ResourceType.myTeam(mid: mid), success: { [weak self] result in
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
    
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int,position:Int,callFrom:String) {

        RemoteClient.request(of: LeagueDetailData.self, target: ResourceType.getMyJoinedLeaguesDetail(mid: mid, lid: lid), success: { [weak self] result in
            guard let ws = self else {return}
            switch result {
            case .success(let data):
            //    ws.presenter?.didFinishFetchingData(list: data, callFrom: callFrom)
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
    
}


