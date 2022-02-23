//
//  AFUtility.swift
//  WeatherTrail
//
//  Created by comviva on 13/02/22.
//

import Foundation
import Alamofire

class AFUtility{
    let apikey = "1331d9e90cd37379fe3b51966ed7480b"
    private init(){}
    
    //MARK: - USING ESCAPING CLOSURE TO
    //MARK: - GET PARTICULAR API
    
    static var instance  = AFUtility()
    func getDailyData(Lat:Double,Long:Double,unit:String,completion: @escaping(DailyForecast)->Void){
        let openURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(Lat)&lon=\(Long)&exclude=minutely,alerts,hourly&units=\(unit)&appid=\(apikey)"
        print("URL:\(openURL)")
        guard let url = URL(string: openURL)else{
            print("Failed to get URL")
            return
        }
        print("process Success")
        Session.default.request(url).responseDecodable(of: DailyForecast.self){ (resp) in
            print("Working..")
            if resp.error == nil {
                print("Success")
                switch resp.result{
                    
                case .success(let data):
                    print("Response received:\(data.daily.count)")
                    completion(data)
                case .failure(let err):
                    print("Unable to get response:\(String(describing: err.errorDescription))")
                }
            }
            else{
                print("Error:\(resp.error?.localizedDescription ?? "some errior")")
            }
        }
    }
    
    func downloadImage(imgURL:String,completion: @escaping (Data)->Void){
        if let url = URL(string: imgURL){
            Session.default.download(url).responseData { (imgData) in
                switch imgData.result{
                    
                case .success(let data):
                    print("Image Downloaded")
                    completion(data)
                case .failure(let err):
                    print("Error downloading\(String(describing: err.errorDescription))")
                }
            }
        }
        
    }
    
    
    //MARK: - USING ANY OBJECT TO GET API RESPONSE
    
    func forecastData(Lat:Double,Long:Double,unit:String,exclude:String,completion: @escaping(Any)->Void){
        let openURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(Lat)&lon=\(Long)&exclude=minutely,alerts,\(exclude)&units=\(unit)&appid=\(apikey)"
        print("URL:\(openURL)")
        guard let url = URL(string: openURL)else{
            print("Failed to get URL")
            return
        }
        print("process Success")
        if exclude == "hourly"{
            Session.default.request(url).responseDecodable(of:DailyForecast.self){ (resp) in
                print("Working..")
                if resp.error == nil {
                    print("Success")
                    switch resp.result{
                        
                    case .success(let data):
                        print("Response received:\(data.daily.count)")
                        completion(data)
                    case .failure(let err):
                        print("Unable to get response:\(String(describing: err.errorDescription))")
                    }
                }
                else{
                    print("Error:\(resp.error?.localizedDescription ?? "some errior")")
                }
            }
        }else{
            Session.default.request(url).responseDecodable(of: HourlyForecast.self){ (resp) in
                print("Working..")
                if resp.error == nil {
                    print("Success")
                    switch resp.result{
                        
                    case .success(let data):
                        print("Response received:\(data.hourly.count)")
                        completion(data)
                    case .failure(let err):
                        print("Unable to get response:\(String(describing: err.errorDescription))")
                    }
                }
                else{
                    print("Error:\(resp.error?.localizedDescription ?? "some errior")")
                }
            }
        }
        
    }
    //MARK: - USING NATIVE FUNCTION INSTEAD OF CLOUSRE
    
    
// End of Class AFutility
}

