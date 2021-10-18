//
//  BaseProtocol.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation

protocol Presentable: AnyObject {
    func willLoadData()
    func didLoadData()
    func didFail(error: CustomError)
}

protocol iPresenter {
    init(view: Presentable)
    func initInteractor()
}
