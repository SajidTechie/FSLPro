//

//  JoinLeagueMsgPopup.swift

//  Dummy

//

//  Created by Apple on 25/09/21.

//

import UIKit





class JoinLeagueMsgPopup: UIViewController {



    @IBOutlet weak var lblMessage : UILabel!

    //@IBOutlet weak var btnClose : UIButton!

    var joinMsg = String()

   

    



    @IBAction func btnClose(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)

    }

    

    override func viewDidLoad() {

        super.viewDidLoad()

        

        if(joinMsg.isEmpty){

            lblMessage.text = "League Joined !"

        }else{

            lblMessage.text = joinMsg

        }

        

        



    }

    

   

  

}
