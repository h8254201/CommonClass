//
//  ViewControllerBaseDelegate.swift
//  NewGolf
//
//  Created by ntub on 2017/3/5.
//  Copyright © 2017年 ntubimdbirc. All rights reserved.
//

import UIKit
protocol ViewControllerBaseDelegate {
    func PresenterCallBack(datadic:NSDictionary,success:Bool,type:String)
    func PresenterCallBackError(error:NSError,type:String)
}
