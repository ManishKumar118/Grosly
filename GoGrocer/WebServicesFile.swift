
import Foundation
import SystemConfiguration
import UIKit
import Alamofire

typealias WSCompletionBlock = (_ data: NSDictionary?) ->()
typealias WSCompletionStringBlock = (_ data: String?) ->()


extension WebServices {
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    
    func POSTFunctiontoGetDetails(data:[String:Any],serviceType:String, showIndicator:Bool, completionBlock:@escaping WSCompletionBlock){
        
        postRequest(urlString: baseUrlTest + serviceType , showIndicator:showIndicator,bodyData: data,completionBlock: completionBlock)
    }
    
    func hitAPiTogetDetails(serviceType:String, completionBlock:@escaping WSCompletionBlock){
        getRequest(urlString: serviceType,completionBlock: completionBlock)
    }
    
    func hitAPiTogetDetailsChat(serviceType:String, completionBlock:@escaping WSCompletionBlock){
        getRequest(urlString: serviceType,completionBlock: completionBlock)
    }
}

class WebServices: URLSession {
    var headers = ""
    func postRequest(urlString:String,showIndicator:Bool, bodyData:[String : Any],completionBlock:@escaping WSCompletionBlock) -> () {
        if isKeyExists(key: LoginDetailKey) {
            headers = fetchString(key: "token") as! String
        }
        headers = authKey
        if showIndicator {
            // AppDelegate.getAppDelegate().showIndicator()
        }
        
        let status = isInternetAvailable()
        print(status)
        if !(status) {
            completionBlock([:])
            return
        }
        print("Hitting URL with Post Request : \n \(urlString) \n\n params : \n \(bodyData)")
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        guard let requestUrl = URL(string:urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: requestUrl as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        request.httpMethod = "POST"
        // request.httpBody = jsonData
        
        let postString = self.getPostString(params: bodyData)
        request.httpBody = postString.data(using: .utf8)
        request.addValue(headers, forHTTPHeaderField: "Auth-key")
        
        // request.setValue("application/json", forHTTPHeaderField: "Accept")
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let responseError = error{
                completionBlock([:])
                
                // AppDelegate.getAppDelegate().hideIndicator()
                print("Response error: \(responseError)")
            }
            else
            {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(dictionary)
                    DispatchQueue.main.async(execute: {
                        // AppDelegate.getAppDelegate().hideIndicator()
                        completionBlock(dictionary)
                    })
                }
                catch let jsonError as NSError{
                    print("JSON error: \(jsonError.localizedDescription)")
                    
                    DispatchQueue.main.async(execute: {
                        // AppDelegate.getAppDelegate().hideIndicator()
                        completionBlock([:])
                    })
                }
            }
        }
        // self.serverResponse(response: data, error: error! as NSError, completionBlock: completionBlock)
        // check for any errors
        
        task.resume()
        
    }
    
    func getRequest(urlString:String,completionBlock:@escaping WSCompletionBlock) -> () {
        print("Hitting URL with Get Request : \n \(urlString)")
        let status = isInternetAvailable()
        print(status)
        if !(status) {
            //let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            //alert.show()
            completionBlock([:])
            return
        }
        
        guard let requestUrl = URL(string:urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: requestUrl as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if let responseError = error{
                completionBlock([:])
                
                // AppDelegate.getAppDelegate().hideIndicator()
                print("Response error: \(responseError)")
            }
            else
            {
                do {
                    
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(dictionary)
                    DispatchQueue.main.async(execute: {
                        completionBlock(dictionary)
                    })
                }
                catch let jsonError as NSError{
                    print("JSON error: \(jsonError.localizedDescription)")
                    completionBlock([:])
                }
            }
        }
        // self.serverResponse(response: data, error: error! as NSError, completionBlock: completionBlock)
        // check for any errors
        
        task.resume()
        
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    func requestWithGet(baseUrl: String, endUrl: String,onCompletion: (([String:Any]) -> Void)? = nil , onError: ((Error?) -> Void)? = nil){
        let url = baseUrl + endUrl
        Alamofire.request(url, method: .get ).responseJSON { response in
            
            switch response.result{
            case .success:
                onCompletion!(response.result.value as! [String:Any])
            case .failure:
                onError!( nil)
            }
        }
    }
    
    func requestWithPost(baseUrl: String, endUrl: String,parameters: [String:String], onCompletion: (([String:Any]) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = baseUrl + endUrl
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion!(response.result.value as! [String:Any])
                case .failure:
                    onError!( nil)
                }
        }
    }
    
    
    
    
    
    
}// extension for impage uploading


