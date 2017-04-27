//
//  UrlSessionDelegate.swift
//  NewGolf
//
//  Created by ntub on 2017/3/5.
//  Copyright © 2017年 ntubimdbirc. All rights reserved.
//

import UIKit
protocol UrlSessionDelegate {
    func SessionFinish(data:NSData)
    func SessionFinishError(error:NSError)
}
