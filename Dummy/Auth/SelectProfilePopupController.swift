//
//  SelectProfilePopupController.swift
//  Dummy
//
//  Created by Goldmedal on 20/03/22.
//

import UIKit

public protocol CellSelectionDelegate: AnyObject {
    func cellSelected(model:Any?)
}

class SelectProfilePopupController: UIViewController {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var strTitle: String? = ""
    var fromPage = ""
    var genderArray = [GenderData]()
    var pincodeArray: [PincodeData] = []
    
    //Delegate Init
    var delegate: CellSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeader.text = strTitle
        
        if(fromPage == "gender"){
            genderArray.append(GenderData(genderName: "MALE", genderAnnotation: "M"))
            genderArray.append(GenderData(genderName: "FEMALE", genderAnnotation: "F"))
            genderArray.append(GenderData(genderName: "TRANSGENDER", genderAnnotation: "T"))
            genderArray.append(GenderData(genderName: "OTHERS", genderAnnotation: "O"))
            
            
            
        }else if(fromPage == "city"){}
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
       {
           let touch = touches.first
           if touch?.view != self.vwMain
           { self.dismiss(animated: false, completion: nil) }
       }
    
    
}




extension SelectProfilePopupController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fromPage == "gender"{
            return genderArray.count
        }
        else if fromPage == "city"{
            return pincodeArray.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenderCell", for: indexPath) as! GenderCell
        if fromPage == "gender"{
            cell.lblGender.text = genderArray[indexPath.row].genderName
        }else if fromPage == "city"{
            cell.lblGender.text = pincodeArray[indexPath.row].city
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension SelectProfilePopupController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if fromPage == "gender"{
                    delegate?.cellSelected(model: genderArray[indexPath.row])
                }
                else if fromPage == "city"{
                    delegate?.cellSelected(model: pincodeArray[indexPath.row])
                }
                dismiss(animated: false)
    }
}


