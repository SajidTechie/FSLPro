//
//  TeamsInteractor.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

protocol TeamsInteractable: AnyObject {
    func didFinishFetchingData(list: [Any],callFrom:String)
    func didFailFetchingData(error: CustomError,callFrom:String)
}

protocol iTeamsInteractor {
    init(presenter: TeamsInteractable)
   
    func myTeamName(mid:Int,callFrom:String)
    func createEditTeam(mid:Int,teamid: Int,teamDetails:[playerDetailObj],callFrom:String)
    func selectedTeam(mid:Int,teamid: Int,callFrom:String)
    func teamPoints(mid: Int,teamid: Int,callFrom:String)
    func teamRank(mid:Int,callFrom:String)
    func matchAllPlayer(mid:Int,callFrom:String)

}

class TeamsInteractor: iTeamsInteractor {
  
   private weak var presenter: TeamsInteractable?

    required init(presenter: TeamsInteractable) {
        self.presenter = presenter
    }

    func myTeamName(mid:Int,callFrom:String) {

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
    
    
    func createEditTeam(mid: Int, teamid: Int,teamDetails: [playerDetailObj],callFrom:String) {
        RemoteClient.request(of: CreateEditTeamData.self, target: ResourceType.updateTeam(mid: mid, teamid: teamid, teamDetail: teamDetails), success: { [weak self] result in
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
    
    func selectedTeam(mid: Int, teamid: Int,callFrom:String) {
        RemoteClient.request(of: MatchAllPlayerData.self, target: ResourceType.getSelectedTeamList(mid: mid, teamid: teamid), success: { [weak self] result in
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
    
    func teamPoints(mid: Int, teamid: Int,callFrom:String) {
        RemoteClient.request(of: TeamPointsData.self, target: ResourceType.getTeamPoints(mid: mid, teamid: teamid), success: { [weak self] result in
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
    
    func teamRank(mid: Int,callFrom:String) {
        RemoteClient.request(of: TeamRank.self, target: ResourceType.getTeamRank(mid: mid), success: { [weak self] result in
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
    
    func matchAllPlayer(mid: Int,callFrom:String) {
        RemoteClient.request(of: MatchAllPlayerData.self, target: ResourceType.getMatchAllPlayer(mid: mid), success: { [weak self] result in
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


