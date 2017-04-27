//
//  ViewController.swift
//  NewGolf
//
//  Created by ntub on 2017/3/5.
//  Copyright © 2017年 ntubimdbirc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,ViewControllerBaseDelegate{
    var loginpresenter : LoginPresenter?
    @IBOutlet weak var txt_account: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    var appdelegate = UIApplication.shared.delegate as! AppDelegate //整隻程式的全域變數類別
    var loadactivity = LoadActivity()   //跳轉畫面
    private var isKeyboardShown = false //驗盤有無出現
    @IBAction func bt_login(_ sender: Any) { //普通登入
        if txt_account.text != "" && txt_password.text != ""{
            loadactivity.showActivityIndicator(self.view)
            loginpresenter?.login(account: txt_account.text!, password: md5(string: txt_password.text!))
        }
    }
    @IBAction func bt_signup(_ sender: Any) { //註冊
        self.performSegue(withIdentifier: "tosignup", sender: self)
    }
    @IBAction func bt_guest(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginpresenter = LoginPresenter(loginVC: self)
        //        TextView監聽show/hide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self ,action: #selector(LoginViewController.txtdismiss)))
        //TextView監聽show/hide

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        //判斷有沒有登入過
        if UserDefaults.standard.object(forKey: "player") != nil {
            getPlayerJson()
            self.performSegue(withIdentifier: "toScoreBoard", sender: self)
            
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        txt_password = textField
        txt_account = textField
    }
    func keyboardWillShow(note: NSNotification) {
        if isKeyboardShown {
            return
        }
        //        if (currentTextField != textBottom) {
        //            return
        //        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        //        let duration = NSTimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        let keyboardFrameValue = keyboardAnimationDetail[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        //        let keyboardFrame = keyboardFrameValue.CGRectValue()
        
        //        UIView.animateWithDuration(duration, animations: { () -> Void in
        //            self.view.frame = CGRectOffset(self.view.frame, 0, -keyboardFrame.size.height)
        //        })
        isKeyboardShown = true
    }
    
    func keyboardWillHide(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
        })
        isKeyboardShown = false    }
    func txtdismiss(){
        txt_account.resignFirstResponder()
        txt_password.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txt_account.resignFirstResponder()
        txt_password.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getPlayerJson(){
        let urlsession = UrlSession()
        urlsession.SetReceived(data: DefaultUser.playerjson as! String)
        let jsonlogin = urlsession.jsonDictionary()
        let myplayer = jsonlogin.object(forKey: "profile") as! NSDictionary
        let player = appdelegate.player
        player.setPlayerNo(playerno: myplayer.object(forKey: "playerno") as! Int)
        player.setName(name: (myplayer.object(forKey: "name"))! as! String)
        player.setEmail(email: (myplayer.object(forKey: "email"))! as! String)
        player.setLastUpdateTime(lastupdatetime: (myplayer.object(forKey: "lastupdatetime"))! as! String)
        player.setCellPhone(cellphone: (myplayer.object(forKey: "cellphone"))! as! String)
        player.setHandicap(handicap: (myplayer.object(forKey: "handicap"))! as! Float)
        player.setSex(sex: (myplayer.object(forKey: "sex"))! as! Int)
        player.setBirthday(birthday: myplayer.object(forKey: "birthday") as! String)
        player.setPicpath(picpath: myplayer.object(forKey: "picture") as! String)
        player.setPassword(password: md5(string: txt_password.text!))

    }
    func PresenterCallBack(datadic : NSDictionary, success:Bool,type: String) {
        if success{
            let myplayer = datadic.object(forKey: "profile") as! NSDictionary
            let player = appdelegate.player
            player.setPlayerNo(playerno: myplayer.object(forKey: "playerno") as! Int)
            player.setName(name: (myplayer.object(forKey: "name"))! as! String)
            player.setEmail(email: (myplayer.object(forKey: "email"))! as! String)
            player.setLastUpdateTime(lastupdatetime: (myplayer.object(forKey: "lastupdatetime"))! as! String)
            player.setCellPhone(cellphone: (myplayer.object(forKey: "cellphone"))! as! String)
            player.setHandicap(handicap: (myplayer.object(forKey: "handicap"))! as! Float)
            player.setSex(sex: (myplayer.object(forKey: "sex"))! as! Int)
            player.setBirthday(birthday: myplayer.object(forKey: "birthday") as! String)
            player.setPicpath(picpath: myplayer.object(forKey: "picture") as! String)
            player.setPassword(password: md5(string: txt_password.text!))
            DispatchQueue.main.async(execute: { () -> Void in
                self.loadactivity.hideActivityIndicator(self.view)
                self.performSegue(withIdentifier: "toScoreBoard", sender: self)
            })
            
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.view.makeToast(message: "帳號密碼錯誤")
                self.loadactivity.hideActivityIndicator(self.view)
            })
        }
    }
    func PresenterCallBackError(error: NSError, type: String) {
        print(error)
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.view.makeToast(message: "連線逾時")
            self.txt_account.isEnabled = true
            self.txt_password.isEnabled = true
            self.loadactivity.hideActivityIndicator(self.view)
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tosignup"{
            let tableVC = segue.destination as! SignUpViewController
            tableVC.loginVC = self
        }
    }
    func md5(string: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = string.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
}

