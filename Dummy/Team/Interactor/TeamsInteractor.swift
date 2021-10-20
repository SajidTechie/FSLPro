//
//  TeamsInteractor.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

protocol TeamsInteractable: AnyObject {
    func didFinishFetchingData(list: [Any])
    func didFailFetchingData(error: CustomError)
}

protocol iTeamsInteractor {
    init(presenter: TeamsInteractable)
   
    func myTeamName(mid:Int)
    func createEditTeam(mid:Int,teamid: Int,teamDetails:[playerDetailObj])
    func selectedTeam(mid:Int,teamid: Int)
    func teamPoints(mid: Int,teamid: Int)
    func teamRank(mid:Int)
    func matchAllPlayer(mid:Int)

}

class TeamsInteractor: iTeamsInteractor {
  
   private weak var presenter: TeamsInteractable?

    required init(presenter: TeamsInteractable) {
        self.presenter = presenter
    }

    func myTeamName(mid:Int) {

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
    
    
    func createEditTeam(mid: Int, teamid: Int,teamDetails: [playerDetailObj]) {
        RemoteClient.request(of: CreateEditTeamData.self, target: ResourceType.updateTeam(mid: mid, teamid: teamid, teamDetail: teamDetails), success: { [weak self] result in
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
    
    func selectedTeam(mid: Int, teamid: Int) {
        RemoteClient.request(of: SelectedTeamData.self, target: ResourceType.getSelectedTeamList(mid: mid, teamid: teamid), success: { [weak self] result in
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
    
    func teamPoints(mid: Int, teamid: Int) {
        RemoteClient.request(of: TeamPointsData.self, target: ResourceType.getTeamPoints(mid: mid, teamid: teamid), success: { [weak self] result in
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
    
    func teamRank(mid: Int) {
        RemoteClient.request(of: TeamRankData.self, target: ResourceType.getTeamRank(mid: mid), success: { [weak self] result in
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
    
    func matchAllPlayer(mid: Int) {
        RemoteClient.request(of: MatchAllPlayerData.self, target: ResourceType.getMatchAllPlayer(mid: mid), success: { [weak self] result in
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


