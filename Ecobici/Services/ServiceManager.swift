//
//  ServiceManager.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation

public class ServiceManager : NSObject, URLSessionDelegate, URLSessionTaskDelegate{
    
    func getAccessToken(referenceController: HomeController){
        let todoEndPoint: String = "https://pubsbapi.smartbike.com/oauth/v2/token"
        
        guard let url = URL(string: todoEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let parameters = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "grant_type": "client_credentials"
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            
            print(error.localizedDescription)
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = setTimeOutRequest
        configuration.timeoutIntervalForResource = setTimeOutResource
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        startRequest(session: session, urlRequest: urlRequest, typeRequest: ACCESS_TOKEN_REQUEST, referenceController: referenceController)
    }
    
    func refreshTokenService(referenceController: MapController){
        let todoEndPoint: String = "https://pubsbapi.smartbike.com/oauth/v2/token"
        
        guard let url = URL(string: todoEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let parameters = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "grant_type": "refresh_token",
            "refreshToken": refreshToken
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            
            print(error.localizedDescription)
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = setTimeOutRequest
        configuration.timeoutIntervalForResource = setTimeOutResource
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        startRequest(session: session, urlRequest: urlRequest, typeRequest: REFRESH_TOKEN_REQUEST, referenceController: referenceController)
    }
    
    func stationsService(referenceController: MapController){
        let todoEndPoint: String = "https://pubsbapi.smartbike.com/api/v1/stations.json"
        
        guard let url = URL(string: todoEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = setTimeOutRequest
        configuration.timeoutIntervalForResource = setTimeOutResource
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        startRequest(session: session, urlRequest: urlRequest, typeRequest: STATIONS_REQUEST, referenceController: referenceController)
    }
    
    func startRequest(session: URLSession, urlRequest: URLRequest, typeRequest: Int, referenceController: AnyObject){
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio")
                print(error!)
                
                DispatchQueue.main.async{
                    
                    self.showErrors(referenceController: referenceController)
                }
                
                return
            }
            
            guard let responseData = data else {
                print("Error: servicio viene vacio")
                
                DispatchQueue.main.async{
                    
                    self.showErrors(referenceController: referenceController)
                }
                
                return
            }
            
            print("la respuesta es")
            let realResponse = response as! HTTPURLResponse
            
            switch realResponse.statusCode {
            case 200:
                do {
                    //print("es diccionario")
                    //print(finalResponse.description)
                    
                    switch typeRequest{
                    case ACCESS_TOKEN_REQUEST:
                        guard let tokenObject = try? JSONDecoder().decode(AccessToken.self, from: responseData) else {
                            print("Error al parsear el JSON, error en las credenciales")
                            
                            DispatchQueue.main.async{
                                
                                self.showErrors(referenceController: referenceController)
                            }
                            
                            return
                        }
                        
                        DispatchQueue.main.async{
                            self.accessTokenResponse(finalResponse: tokenObject, referenceController: referenceController as! HomeController)
                        }
                    case REFRESH_TOKEN_REQUEST:
                        print("")
                    case STATIONS_REQUEST:
                        /*guard let stations = try? JSONDecoder().decode(Stations.self, from: responseData) else {
                            print("Error al parsear el JSON, error en las estaciones")
                            
                            DispatchQueue.main.async{
                                
                                self.showErrors(referenceController: referenceController)
                            }
                            
                            return
                        }
                        */
                        guard let finalResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: AnyObject] else {
                                print("No es diccionario")
                                
                                guard (try JSONSerialization.jsonObject(with: responseData, options: [])
                                    as? [[String: AnyObject]]) != nil else {
                                        print("No es Arreglo")
                                        return
                                }
                                
                                return
                        }
                        
                        let stations: [[String:AnyObject]] = finalResponse["stations"] as! [[String:AnyObject]]
                        
                        print(stations)
                        
                        DispatchQueue.main.async{
                            self.stationsResponse(finalResponse: stations, referenceController: referenceController as! MapController)
                        }
                    default:
                        break
                    }
                    
                    
                } catch  {
                    print("error al parsear el json")
                    
                    return
                }
                
            default:
                print("Estatus http no manejado \(realResponse.statusCode)")
                
                DispatchQueue.main.async{
                    
                    self.showErrors(referenceController: referenceController)
                }
            }
            
        }
        task.resume()
    }
    
    func accessTokenResponse(finalResponse: AccessToken, referenceController: HomeController){
        accessToken = finalResponse.access_token ?? ""
        refreshToken = finalResponse.refresh_token ?? ""
        
        referenceController.showMapController()
    }
    
    func stationsResponse(finalResponse: [[String:AnyObject]] , referenceController: MapController){
        referenceController.showStationsInMap(stations: finalResponse)
    }
    
    func showErrors(referenceController: AnyObject){
        if let controller = referenceController as? HomeController{
            controller.errorsEvents()
        }
        else if let controller = referenceController as? MapController{
            controller.errorsEvents()
        }
    }
    
    
}
