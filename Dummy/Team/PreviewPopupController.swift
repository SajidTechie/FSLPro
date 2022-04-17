//
//  PreviewPopupController.swift
//  Dummy
//
//  Created by Goldmedal on 02/03/22.
//

import UIKit

class PreviewPopupController: UIViewController {
    var strOwnerName = String()
    var strOwnerRank = String()
    var strOwnerPoints = String()
    
    var mid = Int()
    var tid = Int()
    
    var showHeader = false
    var showPoints = false
    var selectedPlayerList: [MatchAllPlayerData]? = []
    @IBOutlet weak var previewPopupView : PreviewPopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewPopupView.delegate = self
        
        previewPopupView.setHeaderValue(strOwnerName:strOwnerName,strOwnerRank:strOwnerRank,strOwnerPoints:strOwnerPoints)

        // Do any additional setup after loading the view.
        previewPopupView.reloadPreview(showHeader: showHeader)
        
        if(showPoints){
            previewPopupView.callTeamPointsApi(mid:mid,tid:tid)
        }else{
            previewPopupView.selectedPlayerList = selectedPlayerList
            previewPopupView.setData()
        }
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
       {
           let touch = touches.first
           if touch?.view != self.previewPopupView
           { self.dismiss(animated: false, completion: nil) }
       }
    

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension PreviewPopupController:HandleHeaderBack{
    func onBackClick() {
        print("Clicked back")
        self.dismiss(animated: false, completion: nil)
    }
    
}
