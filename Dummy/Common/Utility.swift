    //
    //  CheckConnection.swift
    //  dealersApp
    //
    //  Created by Goldmedal on 4/26/18.
    //  Copyright © 2018 Goldmedal. All rights reserved.
    //
    
    import Foundation
    import SystemConfiguration
    import UIKit
    import MapKit
    import CoreData
    import AVFoundation
    
    public class Utility {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // - - - - - function to check internet - - - - - -
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
        
        // - - - - - - - function to format rupee - - - - - - - -
        class func formatRupee(amount: Double) -> String{
            let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
            formatter.locale = Locale(identifier: "en_IN") // Here indian locale with english language is used
            formatter.numberStyle = .decimal               // Change to `.currency` if needed
            
            if(!amount.isNaN && amount.isFinite){
                let formattedAmount = "\u{20B9}" + formatter.string(from: NSNumber(value: Int(amount.rounded())))! // "10,00,000"
                return formattedAmount
            }
            else{
                return "-"
            }
        }
        
        class func formatRupeeWithDecimal(amount: Double) -> String {
            let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
            formatter.numberStyle = .decimal // Here indian locale with english language is used
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            
            formatter.locale = Locale.current
            
            if(!amount.isNaN && amount.isFinite){
                let formattedAmount = "\u{20B9}" + formatter.string(from: NSNumber(value: Double(amount)))!
                return formattedAmount
            }
            else{
                return "-"
            }
        }
        
        // - - - - - -  function to format date - - - - - -  - -
        class func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            
            if let date = inputFormatter.date(from: dateString) {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = format
                
                return outputFormatter.string(from: date)
            }
            
            return "-"
        }
        
        
        class func formattedDateWithOtherFormat(dateString: String, givenFormat: String,withFormat: String) -> String? {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = givenFormat
            
            if let date = inputFormatter.date(from: dateString) {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = withFormat
                
                return outputFormatter.string(from: date)
            }
            
            return "-"
        }
        
        class func formattedDateFromStringWithTime(dateString: String, withFormat format: String) -> String? {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd:HH:mm:ss.SSSS"
            
            if let date = inputFormatter.date(from: dateString) {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = format
                
                return outputFormatter.string(from: date)
            }
            
            return "-"
        }
        
        func validatePANCardNumber(_ strPANNumber : String) -> Bool{
            let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
            let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
            return panCardValidation.evaluate(with: strPANNumber)
        }
        
        static func verifyUrl (urlString: String?) -> Bool {
            if let urlString = urlString {
                if let url = NSURL(string: urlString) {
                    return true
                }
            }
            return false
        }
        
        
        
        func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            let hours: Int = totalSeconds / 3600
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        class func currencyFormat(amount: Double) -> String{
                let numberFormatter = NumberFormatter()
                numberFormatter.groupingSeparator = ","
                numberFormatter.groupingSize = 3
                numberFormatter.usesGroupingSeparator = true
                numberFormatter.numberStyle = .none
                numberFormatter.maximumFractionDigits = 0
                return numberFormatter.string(from: amount as NSNumber)!
            }
        
        
        // - - - -  - - - - - function to get current date  - -  - - - - - - --
        class func currDate() -> String
        {
            //Get current date
            let currDate = Date()
            var dateFormatter = DateFormatter()
            var strCurrDate = ""
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strCurrDate = dateFormatter.string(from: currDate)
            strCurrDate = Utility.formattedDateFromString(dateString: strCurrDate, withFormat: "MM/dd/yyyy")!
            
            return strCurrDate
        }
        
        //For downloading pdf file
        private static var session:URLSession = URLSession(configuration: .default)
        private static var downloadTask: URLSessionDownloadTask?
        
        private static func getLocalDirectory() -> URL? {
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentPath = paths.first
            let directoryPath = documentPath?.appendingPathComponent("Downloads")
            
            guard let path = directoryPath else {
                return nil
            }
            
            if !FileManager.default.fileExists(atPath: path.absoluteString) {
                do {
                    try FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
                }catch {
                    
                }
            }
            print("Path -- -- ",path)
            return path
        }
        
        
        
        public static func downloadFile(fileName:String, url:URL) {
            downloadTask = session.downloadTask(with: url, completionHandler: { (_location, _response, _error) in
                if _error == nil {
                    guard  let location = _location, var folderPath = getLocalDirectory() else {
                        return
                    }
                    
                    folderPath = folderPath.appendingPathComponent(fileName)
                    folderPath.appendPathExtension(".pdf")
                    
                    print("Filename -- -- ",fileName," -- --",url)
                    
                    do {
                        try FileManager.default.moveItem(at: location, to: folderPath)
                    }catch {
                        
                    }
                }
            })
            
            downloadTask?.resume()
        }
        
        // - - - - - - -  function to get current financial year -  - - - - - - - - - -
        class func currFinancialYear() -> String {
            var finYear = "2019-2020"
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            
            if (month >= 4) {
                finYear = String(String(year) + "-" + String(year + 1))
            } else {
                finYear = String(String(year - 1) + "-" + String(year))
            }
            return finYear
        }
        
        // - - - - - - - - function to get device id  - - - - - - - - - -
        class func getDeviceId() -> String? {
            var  deviceId = UIDevice.current.identifierForVendor!.uuidString
            if(deviceId.isEqual("")){
                deviceId = "-"
            }
            return (deviceId ?? "")
        }
        
        // - - - - - - - - - - function to get os version  - - - - - - -
        class func getOSVersion()->String? {
            var osVersion = UIDevice.current.systemVersion
            if(osVersion.isEqual("")){
                osVersion = "-"
            }
            return (osVersion ?? "")
        }
        
        // - - - - - - - - - function to get ip address  - - - - - - - --  -
        class func getIPAddress() -> String? {
            var address : String?
            
            // Get list of all interfaces on the local machine:
            var ifaddr : UnsafeMutablePointer<ifaddrs>?
            guard getifaddrs(&ifaddr) == 0 else { return nil }
            guard let firstAddr = ifaddr else { return nil }
            
            // For each interface ...
            for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
                let interface = ifptr.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    let name = String(cString: interface.ifa_name)
                    if  name == "en0" || name == "pdp_ip0" {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
            
            return (address ?? "")!
        }
        
        // - - - - - - - - function to check if email is valid - - - - - - - --
        class func isValidEmail(emailStr:String) -> Bool {
            let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
            return testEmail.evaluate(with: emailStr)
        }
        
        // - - - - - - - - function to check if mobile number is valid - - - - - - - - -
        class func isValidPhone(phoneStr:String) -> Bool {
            let regularExpressionForPhone = "^[0-9]{10}$"
            let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
            return testPhone.evaluate(with: phoneStr)
        }
        
//        static func showMessage(title: String, msg: String) {
//            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//        }
        
        static func showMessage(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
        
        static func showMessageWithDismiss(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
            }))
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
        
       
        
        class func callNumber(phoneNumber:String) {
          if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
          }
        }
        
        
        static func getToken() -> String {
            let token =  UserDefaults.standard.value(forKey: "Token") as? String ?? ""
            return token
        }
        

       
        
        func btnNotification(count:Int)-> UIButton{
               let button = UIButton()
               
               let image = UIImage(named:"notification")
               button.setImage(image, for: .normal)
               button.imageView?.contentMode = .scaleAspectFit
               button.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
               button.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:10) //adjust these to have fit right
             
               let label = UILabel(frame: CGRect(x: 50, y: 0, width: 50, height: 50))
               label.text = String(count)
               label.font = UIFont(name: "Roboto-Bold", size: 18.0)
               label.textAlignment = .left
               label.textColor = UIColor.red
               
               button.addSubview(label)
               
               return button
           }
        
      
        class func getTopMostViewController() -> UIViewController? {
            var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

            while let presentedViewController = topMostViewController?.presentedViewController {
                topMostViewController = presentedViewController
            }

            return topMostViewController
        }

       
        
        
    }
    
    
    extension UIApplication {
        
        static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
            
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            
            return base
        }
    }
    
    extension String {
        func stringBefore(_ delimiter: Character) -> String {
            if let index = firstIndex(of: delimiter) {
                return String(prefix(upTo: index))
            } else {
                return ""
            }
        }
        
        func stringAfter(_ delimiter: Character) -> String {
            if let index = firstIndex(of: delimiter) {
                return String(suffix(from: index).dropFirst())
            } else {
                return ""
            }
        }
    }

