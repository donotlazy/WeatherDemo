//
//  RequestManager.swift
//  WeatherDemo
//
//  Created by  mshen on 2018/11/15.
//  Copyright © 2018年 enhance. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

//"APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"  Authorization
//"北京" cityName


class RequestManager {
    
    class func requestResult() {
        
    let weatherInfoURL = "http://weatherapi.market.alicloudapi.com/weather/TodayTemperatureByCity"
    let params = ["cityName":"北京"]
    let headers = ["Authorization":"APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"];
        Alamofire.request(weatherInfoURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
