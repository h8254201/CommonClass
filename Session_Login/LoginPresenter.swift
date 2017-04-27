//
//  LoginPresenter.swift
//  NewGolf
//
//  Created by ntub on 2017/3/5.
//  Copyright © 2017年 ntubimdbirc. All rights reserved.
//

import UIKit
class LoginPresenter:BasePresenter{
    var status = ""
    var loginVC : LoginViewController
    init(loginVC:LoginViewController) {
        self.loginVC = loginVC
    }
    func login(account:String,password:String){
        let urlsession = UrlSession(url: ServerContentURL.signin,delegate:self)
        let jsonb = JSONBuilder()
        status = "Login"
        jsonb.addItem(key: "email", value: account)
        jsonb.addItem(key: "password", value: password)
        jsonb.addItem(key: "action", value: "signin")
        urlsession.setupJSON(json: jsonb.value())
        urlsession.postJSON()
    }
    override func SessionFinish(data: NSData) {
        let urlsession = UrlSession()
        let jsondictionary = urlsession.jsonDictionary(json: data)
        let result = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        let temp_result = jsondictionary.object(forKey: "result") as! Int
        if temp_result == 1{
            print(result)
            loginVC.PresenterCallBack(datadic: jsondictionary, success: true, type: status)
        }else{
            loginVC.PresenterCallBack(datadic: jsondictionary, success: false, type: status)
        }
        
    }
    override func SessionFinishError(error: NSError) {
        loginVC.PresenterCallBackError(error: error, type: "")
    }
}
