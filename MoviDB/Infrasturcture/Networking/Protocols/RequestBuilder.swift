//
//  RequestBuilder.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation

protocol RequestBuilder {
    
    //MARK: Protocol Definition
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var requestType: RequestMethod { get }
}

//MARK: Protocol Extension
extension RequestBuilder {
    
    /*
     buildComponent() builds URLComponent and passes it on to concrete network manager
     */
    
    func buildComponent() -> URLComponents {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = queryItems
        return component
    }
}
