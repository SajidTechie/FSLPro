//
//  BaseProtocol.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation

protocol Presentable: AnyObject {
    func willLoadData(callFrom:String)
    func didLoadData(callFrom:String)
    func didFail(error: CustomError,callFrom:String)
}

protocol iPresenter {
    init(view: Presentable)
    func initInteractor()
}
