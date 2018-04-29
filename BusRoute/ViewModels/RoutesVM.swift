//
//  RoutesVM.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/26/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class RoutesVM {

    public private (set) var routes : [Route] = []
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((String)->())?
    
    func fetchRoutes(urlString : String){
        
        guard let url = URL(string: urlString) else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let client = NetworkClient(session: URLSession(configuration: .default))
        
        client.get(url: url, callback: { [weak self] (data, response, error) in
            
            guard let strongSelf = self else { return }
            
            defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
            }
            
            guard let data = data, error == nil else{
                print("Image download failed: \(String(describing: error))")
                strongSelf.showAlertClosure?((error?.localizedDescription)!)
                return
            }
            
            let resp = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            strongSelf.routes = Route.array(jsonArray: resp)
            
            DispatchQueue.main.async{
                    strongSelf.reloadTableViewClosure?()
            }
            
            
        })
    }
}
