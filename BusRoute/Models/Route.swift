//
//  Route.swift
//  BusRoute
//
//  Created by Tomislav Luketic on 4/26/18.
//  Copyright © 2018 lux. All rights reserved.
//

import UIKit

class Route {

    let id : String
    let accessible : Bool
    let imageUrl : String?
    let name : String
    let description : String
    let stops : [[String:String]]
    
    internal struct Keys {
        static let id = "id"
        static let accessible = "accessible"
        static let imageUrl = "imageUrl"
        static let name = "name"
        static let description = "description"
        static let stops = "stops"
       
    }
    
    public init?(json: [String: Any]) {
        
        guard let id = json[Keys.id] as? String,
            let accessible = json[Keys.accessible] as? Bool,
            let name = json[Keys.name] as? String,
            let description = json[Keys.description] as? String,
            let stops = json[Keys.stops] as? [[String:String]]
            else { return nil }
        
        self.id = id
        self.accessible = accessible
        self.imageUrl = json[Keys.imageUrl] as? String
        self.name = name
        self.description = description
        self.stops = stops
        
    }
    
    public class func array(jsonArray: [[String: Any]]) -> [Route] {
        var array: [Route] = []
        for json in jsonArray {
            guard let product = Route(json: json) else { continue }
            array.append(product)
        }
        return array
    }
    
    
    
    
}
