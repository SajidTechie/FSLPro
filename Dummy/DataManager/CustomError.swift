//
//  CustomError.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation
enum CustomError: Error,Equatable {
  
    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
//        if(lhs == rhs){
            return true
//        }else{
//            return false
//        }
//
    }
    
  
    case UnableToConnect
    case NoNetwork //1009
    case HTTPError(err:Error)
    case ServerError
    case TimeOut //2102
    case ParsingError
    case BadRequest
    case DatabaseError
    case TokenError
  
    
    var localizedDescription: String {
        switch  self {
        case .UnableToConnect:
            return StringConstants.server_error
        case .NoNetwork:
            return StringConstants.no_internet
        case .HTTPError(let error):
            return StringConstants.server_error
        case .TimeOut:
            return StringConstants.server_error
        case .ParsingError:
            return StringConstants.no_data
        case .BadRequest:
            return StringConstants.server_error
        case .ServerError:
            return StringConstants.server_error
        case .DatabaseError:
            return StringConstants.no_data
        case .TokenError:
            return StringConstants.token_expired
        }
    }
}


//var localizedDescription: String {
//    switch  self {
//    case .UnableToConnect:
//        return "Unable to Connect to server"
//    case .NoNetwork:
//        return "No Network"
//    case .HTTPError(let error):
//        return "Response Error: \(error.localizedDescription)"
//    case .TimeOut:
//        return "The request has timed out."
//    case .ParsingError:
//        return "Unable to Serialize."
//    case .BadRequest:
//        return "Something went wrong, network failure!"
//    case .ServerError:
//        return "Server Error."
//    case .DatabaseError:
//        return "Local storage error, try again!"
//    case .TokenError:
//        return StringConstants.token_expired
//    }
//}
