//
//  UrlSession.swift
//  Golf
//
//  Created by ntub on 2016/7/21.
//  Copyright © 2016年 ntubimdbirc. All rights reserved.
//

import UIKit
class UrlSession: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    fileprivate var delegate : UrlSessionDelegate?
    var urlstring = ""
    var postString = ""
    var received : NSData?
    var jsonobjects = NSDictionary()
    var params = [String:Any]()
    override init(){}
    init(url:String,delegate:UrlSessionDelegate){
        super.init()
        self.urlstring = url
        self.delegate = delegate
    }
    func setupJSON(json:Dictionary<String, Any>){
        self.params = json
        print(json.debugDescription)
    }
    func postloadallgno(playerno:String){
        self.postString = "playerno=\(playerno)&action=loadallgno"
    }
    func postloadallcourseno(codecountryno:String ,codeareano:String){
        self.postString = "codecountryno=\(codecountryno)&codeareano=\(codeareano)&action=loadallcourseno"
    }
    func postupdateprofile(playerno : String , cellphone : String , name : String , handicap : String){
        self.postString = "playerno=\(playerno)&cellphone=\(cellphone)&name=\(name)&handicap=\(handicap)"
    }
    
    
    func postloadgame(gno:String){
        self.postString = "gno=\(gno)&action=loadgame"
    }

    func postJSON(){
        let successFail :NSDictionary = ["success":0]
        do{
            print("-----------> [Post] Seting connection <----------")
            let request = NSMutableURLRequest(url: NSURL(string: urlstring)! as URL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData , timeoutInterval: 15.0)
            request.httpMethod = "POST"
            print("-----------> [Post] Seting JSON Data <----------")
            print(self.params)
            request.httpBody = try JSONSerialization.data(withJSONObject: self.params, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = URLSession.shared
            let task = session.dataTask(with: (request as NSURLRequest) as URLRequest){data,response,error in
                print("-----------> [Session] Get Response <----------")
                if error != nil{
                    print("-----------> [Session] Response Error <----------")
                    self.delegate?.SessionFinishError(error: error! as NSError)
                }else{
                    print("-----------> [Session] Response Success <----------")
                    _ = ""
                    if data != nil{
                        _ = NSString(data:data!,encoding: String.Encoding.utf8.rawValue)
                        self.received = data as NSData?
                        self.delegate?.SessionFinish(data: data! as NSData)
                    }else{
                        self.delegate?.SessionFinishError(error: error! as NSError)
                    }
                }
            }
            task.resume()
        }catch let error as NSError{
            print("-----------> [Post] Parse JSON Data Error <----------")
            print(error.localizedDescription)
            self.delegate?.SessionFinishError(error: error as NSError)
            self.jsonobjects = successFail
        }
    }
    func getDataFromUrl(url: NSURL, completion:@escaping (_ data: NSData?,  _ response: URLResponse?,  _ error: NSError?) -> Void) {
        URLSession.shared.dataTask(with: url as URL){
            (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
        }.resume()
    }
    func jsonDictionary()->NSDictionary{
        do{
            self.jsonobjects  = try JSONSerialization.jsonObject(with: received! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        }catch{error}
        return self.jsonobjects
    }
    func jsonDictionary(json:NSData)->NSDictionary{
        var jsonob = NSDictionary()
        do{
            jsonob  = try JSONSerialization.jsonObject(with: json as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        }catch{error}
        return jsonob
    }
    func SetReceived(data:String){
        self.received = data.data(using: String.Encoding.utf8) as NSData?
    }
}
