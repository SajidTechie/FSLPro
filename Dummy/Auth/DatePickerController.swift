

import UIKit

class DatePickerController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDateHeader: UILabel!
    
    var isFromDate = false
    var fromDate: Date?
    var toDate: Date?
    
    var initfromDate: Date?
    var inittoDate: Date?
    
    var finYear = ""
    var splitYear = [String]()
    var minYear = ""
    var maxYear = ""
    var strFromDate = ""
    var strToDate = ""
    var strInitToDate = ""
    
    var dateFormatter = DateFormatter()
    var selectedDate = ""
    var callFrom = ""
    
    let setStrInitFromDate = "1900-01-01"
    let setStrInitToDate = "2030-01-01"
    
    var delegate: CommonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DATE - - - ",fromDate,"- - - - - ",toDate)
        
        print("DATE INIT - - - ",initfromDate,"- - - - - ",inittoDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        let setInitFromDate = dateFormatter.date(from: setStrInitFromDate)
        let setInitToDate = dateFormatter.date(from: setStrInitToDate)
        
        if(callFrom.elementsEqual("DateTime")){
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            
            datePicker.datePickerMode = .dateAndTime
            
            datePicker.date = fromDate ?? Date()
            datePicker.minimumDate = Date()
            datePicker.maximumDate = setInitToDate
            
        }else if(callFrom.elementsEqual("DOB")){
           
            datePicker.date = fromDate!
            datePicker.minimumDate = setInitFromDate
            datePicker.maximumDate = fromDate!
            
        }else{
            if isFromDate {
                datePicker.date = fromDate ?? Date()
                datePicker.minimumDate = setInitFromDate
                
                if let toDate = toDate {
                    datePicker.maximumDate = toDate
                } else {
                    datePicker.maximumDate = Date()
                }
            } else {
                datePicker.date = toDate ?? Date()
                datePicker.maximumDate = setInitToDate
                
                if let fromDate = fromDate {
                    datePicker.minimumDate = fromDate
                } else {
                    //
                }
                // datePicker.maximumDate = Date()
            }
            
        }
        
    }
    
    
    
    @IBAction func cancel_clicked(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    
    @IBAction func ok_clicked(_ sender: UIButton) {
        if(callFrom.elementsEqual("DateTime")){
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        }else{
            dateFormatter.dateFormat = "dd-MMM-yyyy"
        }
        
        selectedDate = dateFormatter.string(from: datePicker.date)
        delegate?.updateDate!(value: selectedDate, date: datePicker.date)
        dismiss(animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
