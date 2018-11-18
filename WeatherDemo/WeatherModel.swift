//
//  WeatherModel.swift
//  WeatherDemo
//
//  Created by  mshen on 2018/11/18.
//  Copyright © 2018年 enhance. All rights reserved.
//

import Foundation
import HandyJSON

class TodayWeather: HandyJSON {
    
    var uv_index: String? ///紫外线指数
    var weather: String? ///天气
    var city: String? ///城市
    var temperature: String? ///温度 格式： -3℃~9℃
    var date_y: String? ///时间 格式2018年11月18日
    var time: String? ///时间23：21
    var humidity: String? ///湿度 格式：14%
    var windStrength: String?  ///风力
    var weather_id: [String: Any]? ///天气ID
    //必须实现
   required init() {}
    
    
}


class FutureWeather:HandyJSON {
    var week: String? /// 星期几
    var temperature: String? /// 温度
    var weather_id: [String: Any]? ///天气ID
    var date: String? ///日期，格式：20181124
    var wind: String? ///风的信息，
    var weather: String? ///天气
    
    //必须实现
    required init() {}
}
