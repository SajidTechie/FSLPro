//
//  DataManager.swift
//  DemoJson
//
//  Created by Rahul on 29/01/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import UIKit


//HTTP Methods
enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class DataManager: NSObject {
    
    static let shared = DataManager();
    private override init() {}
    
    //TODO: remove app transport security arbitary constant from info.plist file once we get API's
    var request : URLRequest?
    var session : URLSession?
    
    
    var strCin = ""
    
    var tokenCount = 0
    
    //MARK: HTTP CALLS
    func makeAPICall(url: String,params: Dictionary<String, Any>?, method: HttpMethod,token: String, success:@escaping ( Any? ) -> Void, failure: @escaping (Error? )-> Void) {
        
       
        if Reachability.isConnectedToNetwork() {
            
            guard let urlBase = URL(string:url) else {
                Utility.showMessage(title: "Error", msg: "Invalid URL")
                failure(nil)
                return
            }
            
            request = URLRequest(url: urlBase,timeoutInterval: Double.infinity)
            request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
            
            if let params = params {
                
                let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                if(!token.elementsEqual("-")){
                    request?.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                request?.httpBody = jsonData
            }
            
            request?.httpMethod = method.rawValue
            
            let configuration = URLSessionConfiguration.default
          
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            
            session = URLSession(configuration: configuration)
        
            
            session?.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
                
                if let data = data {
                    print("Token for \(url) - - - ",token)
                    if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                        
                        DispatchQueue.main.async {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    // try to read out a string array
                                    
                                    let statusCode = json["StatusCode"] as? Int
                                     print("Status Code inside http - - - - ",statusCode)
                                     
                                    let statusCodeMessage = json["StatusCodeMessage"] as? String
                                    
                                    if(statusCode == 401 || statusCode == 403){
                                        // - - - - Token is expired - - - - -
                                        print("Token is expired")
                                        print("status code is \(statusCode) - - - - ","( \(url) ) - - - --  -- ",data)
                                        
                                        self.makeAPITokenCallNew(url: url, params: params, method: method,callFrom: "", statusCode: statusCode!, success: success, failure: failure)
                                    }
                                    else if(statusCode == 402){
                                         let jsonErrArray = json["Errors"] as? [[String: Any]]
                                         print(jsonErrArray)
                                        
                                         var msg = ""
                                        if(jsonErrArray?.count ?? 0 > 0){
                                            msg = jsonErrArray?[0]["ErrorMsg"] as? String ?? "Logged Out Successfully"
                                         }
                                         
                                         print("** ** ** message for 402 - - - ",msg)
                                        
                                        
                                        // - - - - Force Logout - - - - -
                                        print("status code is 402 - - - - ","( \(url) ) - - - --  -- ",data)
                                        
                                        self.logout(message: msg, statusCode: statusCode ?? 402)
                                      
                                        ViewControllerUtils.sharedInstance.removeLoader()
                                       // failure(error)
                                        
                                    }
                                    else{
                                        print("status code is 200 - - - - ","( \(url) ) - - - --  -- ",data)
                                        success(data)
                                    }
                                }
                            } catch let err {
                                print("Error catch exception in main - - - - ", err)
                                failure(error)
                            }
                            
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            failure(error)
                        }
                        
                    }
                }else {
                    
                    DispatchQueue.main.async {
                        failure(error)
                    }
                    
                }
            }.resume()
            
        }
        else
        {
            let error: Error = MyError.customError(message: "No Internet Connection")
            DispatchQueue.main.async {
                failure(error)
            }
        }
    }
    
    
    
    // - - - - - Input body for create access token 401 - - - - - -
    func createAccessTokenBody()->Data{
        
        var strDeviceId = Utility.getDeviceId() ?? "-"
        var strUserName = String(UserDefaults.standard.string(forKey: "userName") ?? "")
        var strPassword = String(UserDefaults.standard.integer(forKey: "password"))
        var strLat = ""
        var strLong = ""
        var strPushId = MyApi.PUSH_ID
        
        let postData = NSMutableData(data: "grant_type=\(GlobalConstants.init().GRANT_TYPE_ACCESS)".data(using: String.Encoding.utf8)!)
        postData.append("&username=\(strUserName)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(strPassword)".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(GlobalConstants.init().CLIENT_ID)".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=\(GlobalConstants.init().CLIENT_SECRET)".data(using: String.Encoding.utf8)!)
        postData.append("&deviceId=\(strDeviceId)".data(using: String.Encoding.utf8)!)
        postData.append("&poooshWooshId=\(strPushId)".data(using: String.Encoding.utf8)!)
        postData.append("&lat=\(strLat)".data(using: String.Encoding.utf8)!)
        postData.append("&lng=\(strLong)".data(using: String.Encoding.utf8)!)
       // print("create token - - - -",postData)
        print("Create token - - - ",GlobalConstants.init().GRANT_TYPE_ACCESS," - - ",strUserName," - - ",strPassword," - - ",GlobalConstants.init().CLIENT_ID," - - ",GlobalConstants.init().CLIENT_SECRET," - - ",strDeviceId," - - ",strPushId," - - ",strLat," - - ",strLong)
        return postData as Data
    }
    
    // - - - - - Input body for create access token 403 - - - - - -
    func refreshAccessTokenBody()->Data{
        
        var strDeviceId = Utility.getDeviceId() ?? "-"
        var strRefreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
        let postData = NSMutableData(data: "grant_type=\(GlobalConstants.init().GRANT_TYPE_REFRESH)".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(GlobalConstants.init().CLIENT_ID)".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=\(GlobalConstants.init().CLIENT_SECRET)".data(using: String.Encoding.utf8)!)
        postData.append("&refresh_token=\(strRefreshToken)".data(using: String.Encoding.utf8)!)
     //   print("refresh token - - - -",postData)
        print("refresh token - - - ",GlobalConstants.init().GRANT_TYPE_REFRESH," - - ",strRefreshToken," - - ",GlobalConstants.init().CLIENT_ID," - - ",GlobalConstants.init().CLIENT_SECRET)
        return postData as Data
    }
    
    
    func logout(message:String,statusCode:Int){
        let defaults = UserDefaults.standard
        let masterUser = defaults.bool(forKey: "masterUser")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        
        print("Logout Status Code - - - -")
        // - - -  - - - - check if master login or not
        if(masterUser && statusCode != 400){
            print("*******  user is master")
            print("KEYS 11 - - - - ",defaults.dictionaryRepresentation().keys.count)
            for key in defaults.dictionaryRepresentation().keys {
                if (!key.hasPrefix("Intro") && !key.hasPrefix("CategorySlNo") && !key.hasPrefix("masterUser") && !key.hasPrefix("password") && !key.hasPrefix("CategoryName") && !key.hasPrefix("CategoryImage") && !key.hasPrefix("mobileNo") && !key.hasPrefix("userName")){
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            
            print("KEYS 22 - - - - ",defaults.dictionaryRepresentation().keys.count)
            
            // - - - - - call login here - - - - -
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcMasterLogin = storyBoard.instantiateViewController(withIdentifier: "MasterLoginController") as! MasterLoginController
            vcMasterLogin.msg = message
            rootViewController.pushViewController(vcMasterLogin, animated: true)
        }else{
            print("*******  user is routine")
            
            print("KEYS 1- - - - ",defaults.dictionaryRepresentation().keys.count)
            
            for key in defaults.dictionaryRepresentation().keys {
                if (!key.hasPrefix("Intro")){
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            
            print("KEYS 2- - - - ",defaults.dictionaryRepresentation().keys.count)
            
            // - - - - - call login here - - - - -
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            vcLogin.msg = message
            rootViewController.pushViewController(vcLogin, animated: true)
        }
        
    }
    
    
    
    // - - - - - - - - ***************************************************************  - - - - - - - - -
    func makeAPITokenCallNew(url: String,params: Dictionary<String, Any>?, method: HttpMethod,callFrom:String,statusCode:Int, success:@escaping ( Any? ) -> Void, failure: @escaping (Error? )-> Void) {
        var newStatusCode = 0
        print("***** COUNT INSIDE TOKEN - - - - ",self.tokenCount)
         
        var request = URLRequest(url: URL(string: MyApi.ACCESS_TOKEN)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var paramsToken : Data?
        
        if(callFrom.elementsEqual("otp")){
            paramsToken = self.createAccessTokenBody()
        }else{
            if(statusCode == 403){
                paramsToken = self.createAccessTokenBody()
            }else if(statusCode == 401){
                paramsToken = self.refreshAccessTokenBody()
            }
        }
        
        request.httpMethod = "POST"
        request.httpBody = paramsToken
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        session = URLSession(configuration: configuration)
        
        session?.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if let data = data {
           
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    DispatchQueue.main.async {
                     
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                // try to read out a string array
                                var newStatusCode = -1
                                newStatusCode = json["StatusCode"] as? Int ?? -1
                              
                                print("Status Code for token - - - - ",newStatusCode," - - - ",json)
                                
                                print("paramsToken - - - - ",paramsToken)
                                
                                let jsonErrArray = json["Errors"] as? [[String: Any]]
                                print(jsonErrArray)
                                
                                var msg = ""
                                if(jsonErrArray?.count ?? 0 > 0){
                                    msg = jsonErrArray?[0]["ErrorMsg"] as? String ?? "Token Error"
                                }
                                
                                // - - - - if status code is 400 that means user is locked
                                let accessToken = json["access_token"] as? String
                                print("new accessToken - - - - - - ",accessToken)
                                
                                let refreshToken = json["refresh_token"] as? String
                                print("new refreshToken - - - - - - ",refreshToken)
                                
                                if(accessToken != nil && refreshToken != nil){
                                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                    self.tokenCount = 0
                                }
                             
                                
                                if(callFrom.elementsEqual("otp")){
                                    //- - - - - call profile on success - - - - -
                                    if(accessToken != nil && refreshToken != nil){
                                        print("** ** ** success token from otp ** ** **")
                                        success(data)
                                    }else{
                                        self.tokenCount = 0
                                        
                                        let defaults = UserDefaults.standard
                                        let masterUser = defaults.bool(forKey: "masterUser")
                                        if(masterUser){
                                            for key in defaults.dictionaryRepresentation().keys {
                                                if (!key.hasPrefix("Intro")){
                                                    UserDefaults.standard.removeObject(forKey: key)
                                                }
                                            }
                                        }
                                      
                                        self.logout(message: msg, statusCode: newStatusCode)
                                        
                                        print("**** Token Error from OTP ****")
                                    }
                                }else{
                                    if(newStatusCode == 401 || newStatusCode == 403){
                                        self.tokenCount += 1
                                        if(self.tokenCount > 3){
                                            //   failure(MyError.customError(message: "Token Error"))
                                            print("******** Infinite loop Token --- ----\(self.tokenCount)*******")
                                            self.tokenCount = 0
                                            self.logout(message: msg, statusCode: newStatusCode)
                                         
                                        }else{
                                            print("NEW TOKEN PARAMS  - - - - -",params)
                                             self.makeAPITokenCallNew(url: url, params: params, method: method,callFrom: "", statusCode: newStatusCode, success: success, failure: failure)
                                        }
                                    }else{
                                        if(accessToken != nil){
                                             self.makeAPICall(url: url, params: params, method: method, token: accessToken ?? "", success: success, failure: failure)
                                        }else{
                                            self.tokenCount = 0
                                            self.logout(message: msg, statusCode: newStatusCode)
                                        }
                                    }
                                }
                                
                            }
                        } catch let err {
                          //  failure(MyError.customError(message: "Token Error"))
                            print("Error catch expection in token - - - ", err)
                            self.tokenCount = 0
                            self.logout(message: "Exception Token Error", statusCode: 400)
                        }
                        
                        
                        //  success(data)
                        print("( \(url) ) - - - --  -- ",data)
                    }
                } else {
                    DispatchQueue.main.async {
                       // failure(MyError.customError(message: "Token Error"))
                        self.tokenCount = 0
                        self.logout(message: "Invalid Token Error", statusCode: 400)
                    }
                }
            }else {
                DispatchQueue.main.async {
                   // failure(MyError.customError(message: "Token Error"))
                    self.tokenCount = 0
                    self.logout(message: "Server Token Error", statusCode: 400)
                }
            }
            
            ViewControllerUtils.sharedInstance.removeLoader()
            
        }.resume()
        
    }
    
}


public enum MyError: Error {
    case customError(message: String)
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError(message: let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}


