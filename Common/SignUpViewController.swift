//
//  SignUpViewController.swift
//  NewGolf
//
//  Created by ntub on 2017/3/22.
//  Copyright © 2017年 ntubimdbirc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,ViewControllerBaseDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var lbl_birthday: UILabel!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirmpaswd: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_cellphone: UITextField!
    @IBOutlet weak var txt_handicap: UITextField!
    
    @IBOutlet weak var btout_confirm: UIButton!
    
    var birthdaytemp : String?
    var loginVC = LoginViewController()
    var signuppresenter : SignUpPresenter?
    private var isKeyboardShown = false //驗盤有無出現
    
    @IBAction func bt_confirm(_ sender: Any) {
        if txt_password.text != txt_confirmpaswd.text{
            self.view.makeToast(message: "confirmpassword fail")
        }else{
            if txt_email.text! == "" || txt_password.text! == "" || txt_confirmpaswd.text! == "" || txt_name.text! == "" || txt_cellphone.text! == "" || txt_handicap.text! == "" || birthdaytemp == nil{
                self.view.makeToast(message: "data fail")
            }else{
                signuppresenter?.signup(email: txt_email.text!, password: md5(string: txt_password.text!), name: txt_name.text!, cellphone: txt_cellphone.text!, handicap: Float(txt_handicap.text!)!, birthday: birthdaytemp!,sex: 0)
            }
        }
    }
    
    @IBAction func bt_back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signuppresenter = SignUpPresenter(SUVC: self)
        setView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updatebirthday(_ sender:UITapGestureRecognizer){
        let editbirthdayVC = SelectBirthdayViewController()
        let alert = UIAlertController(title: "Update Password", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "ok", style: .default, handler: { btaction in
            var updatebirthday = editbirthdayVC.updatebirthday
            if updatebirthday == nil{
                let date = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.lbl_birthday.text = formatter.string(from: date as Date)
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                self.lbl_birthday.text = formatter.string(from: updatebirthday!)
                
                let savetempformatter = DateFormatter()
                savetempformatter.dateFormat = "yyyy-MM-dd"
                self.birthdaytemp = formatter.string(from: updatebirthday!)
            }
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.setValue(editbirthdayVC, forKey: "contentViewController")
        alert.addAction(okaction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func setView(){
        

        
        let updatebirthday = UITapGestureRecognizer(target: self, action: #selector(self.updatebirthday))
        lbl_birthday.textColor = UIColor.white
        lbl_birthday.backgroundColor = UIColor.init(red: 17.0/255.0, green: 143.0/255.0, blue: 288.0/255.0, alpha: 1)
        lbl_birthday.isUserInteractionEnabled = true
        lbl_birthday.addGestureRecognizer(updatebirthday)
        
        scroll.contentSize = CGSize(width: self.scroll.frame.width, height: btout_confirm.frame.origin.y + btout_confirm.frame.size.height )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SignUpViewController.keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SignUpViewController.keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self ,action: #selector(LoginViewController.txtdismiss)))
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        txt_password = textField
        txt_confirmpaswd = textField
        txt_name = textField
        txt_cellphone = textField
        txt_handicap = textField
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
        isKeyboardShown = false
    }
    func txtdismiss(){
        txt_password.resignFirstResponder()
        txt_confirmpaswd.resignFirstResponder()
        txt_name.resignFirstResponder()
        txt_cellphone.resignFirstResponder()
        txt_handicap.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txt_password.resignFirstResponder()
        txt_confirmpaswd.resignFirstResponder()
        txt_name.resignFirstResponder()
        txt_cellphone.resignFirstResponder()
        txt_handicap.resignFirstResponder()
        return true
    }
    func PresenterCallBack(datadic: NSDictionary, success: Bool, type: String) {
        if success{
            DispatchQueue.main.async(execute: { () -> Void in
                self.dismiss(animated: true, completion: nil)
                self.loginVC.view.makeToast(message: "success")
            })
        }
    }
    func PresenterCallBackError(error: NSError, type: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.view.makeToast(message: "signup fail")
        })
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
