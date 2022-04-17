//
//  HeaderWithTimer.swift
//  Dummy
//
//  Created by Goldmedal on 06/03/22.
//

import UIKit

    @IBDesignable class HeaderWithTimer: BaseCustomView {
        @IBOutlet weak var imvBack : UIImageView!
        @IBOutlet weak var lblHeader : UILabel!
        @IBOutlet weak var lblWalletBal : UILabel!
        @IBOutlet weak var lblTimer : UILabel!
        @IBOutlet weak var lblAboutMatch : UILabel!
        var delegate: HandleHeaderBack?
        let Dateformatter = DateFormatter()
       
        var strCurrDate = ""
        
        var matchName = String()
        
        var currentDate = Date()
        var matchDate = Date()
        let calendar = Calendar.current
        
        weak var countdownTimer: Timer?
        
        override func xibSetup() {
            super.xibSetup()
            
            self.Dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
          
            let tabBackImage = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
            imvBack.addGestureRecognizer(tabBackImage)
            
            let tapAboutMatch = UITapGestureRecognizer(target: self, action: #selector(self.tapAboutMatch))
            lblAboutMatch.addGestureRecognizer(tapAboutMatch)
        
        }
        
        
        @objc func tapFunction(sender:UITapGestureRecognizer) {
            print("Edit Icon Clicked")
            countdownTimer?.invalidate()
            delegate?.onBackClick()
        }
        
        
        @objc func tapAboutMatch(sender:UITapGestureRecognizer) {
            print("Edit Icon Clicked")
          //  countdownTimer?.invalidate()
            delegate?.onAboutMatch()
        
        }
      
        func bindHeader(model: Match?){
            
            let strMatchDate = model?.matchDate ?? ""
            lblHeader.text = model?.matchName ?? ""
            lblWalletBal.text = Utility.getWalletBalance()
           
            formatTime(strMatchDate: strMatchDate)
            
            if(self.countdownTimer == nil){
            self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                self.formatTime(strMatchDate: strMatchDate)
            }
            }
         
        }
        
        
        func formatTime(strMatchDate: String){
            let strCurrDate = self.Dateformatter.string(from: Date())
            
            // "yyyy-MM-dd'T'HH:mm:ss"
            //convert string to date
            self.currentDate = self.Dateformatter.date(from: strCurrDate)!
            self.matchDate = self.Dateformatter.date(from: strMatchDate)!
           // self.matchDate = self.Dateformatter.date(from: "2022-03-18T15:07:30")!
            
            var timeLeft = self.calendar.dateComponents([.second], from:self.currentDate, to:self.matchDate).second
            // print("Difference - - - -",timeLeft)
            
            if(timeLeft ?? 0 > 0){
                self.lblTimer.text = Utility.init().timeFormatted(timeLeft ?? 0)
            }else{
                if(timeLeft == 0){
                    delegate?.onTimeOut()
                }else
               { self.lblTimer.text = "-:-:-"}
                
            }
        }
        
        
    }
