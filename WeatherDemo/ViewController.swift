//
//  ViewController.swift
//  WeatherDemo
//
//  Created by  mshen on 2018/11/13.
//  Copyright © 2018年 enhance. All rights reserved.
//

import UIKit
import Hue
import Alamofire
import SwiftyJSON

/// 显示城市天气信息
class ViewController: UIViewController {

    let requestDataKey = "weatherData"

    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var todayWeatherImageView: UIImageView!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTmpLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    var dateFormatter: DateFormatter!
    var todayWeataher: TodayWeather?
    var futureArray: [FutureWeather] = []

    //MARK:- lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if let dict = UserDefaults.standard.value(forKey: requestDataKey) as? [String: Any] {
            self.parseData(data: dict)
        } else {
            self.requestResult()
        }
    }
    
    //MARK:- 请求网络数据
    func requestResult() {
        let weatherInfoURL = "http://weatherapi.market.alicloudapi.com/weather/TodayTemperatureByCity"
        let params = ["cityName":"北京"]
        let headers = ["Authorization":"APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"];
        Alamofire.request(weatherInfoURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if let dict = json["result"].dictionaryObject {
                    UserDefaults.standard.set(dict, forKey: self.requestDataKey)
                    self.parseData(data: dict)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //MARK:- 解析数据
    func parseData(data: [String : Any]) {
        
        print(data)
        let todayDic: Dictionary = data["today"] as! [String : Any]
        let skDict: Dictionary = data["sk"] as! [String : Any]
        let futureDict: Dictionary = data["future"] as! [String : Any]
        self.todayWeataher = TodayWeather.deserialize(from: todayDic)
        
        self.todayWeataher?.humidity = skDict["humidity"] as? String
        self.todayWeataher?.windStrength = skDict["wind_strength"] as? String
        self.todayWeataher?.time = skDict["time"] as? String
        self.todayWeataher?.temperature = skDict["temp"] as? String

        let array = Array(futureDict.values)
        self.futureArray = [FutureWeather].deserialize(from: array) as! [FutureWeather]
        futureArray.sort(by: {(num1: FutureWeather, num2: FutureWeather) -> Bool  in
            let date1 = dateFormatter.date(from: num1.date!)?.timeIntervalSince1970
            let date2 = dateFormatter.date(from: num2.date!)?.timeIntervalSince1970
            return   Double(date1 ?? 0) < Double(date2 ?? 0)
        })
        self.updateUI()
        weekCollectionView.reloadData()
    }
    
    //MARK:- 更新UI
    func updateUI()
    {
//        let weatherIcon = WeatherIcon.init(condition: todayWeataher?.weather_id?["fa"] as! String)
        let name = self.checkWeatherImage(name: todayWeataher?.weather ?? "")
        todayWeatherImageView.image = UIImage.init(named: name)
        cityLabel.text = todayWeataher?.city
        todayWeatherLabel.text = todayWeataher?.weather
        todayTmpLabel.text = todayWeataher?.temperature
        
        updateTimeLabel.text = "\(todayWeataher?.date_y ?? "") \(todayWeataher?.time ?? "") 发布"
        windLabel.text = todayWeataher?.windStrength
        uvIndexLabel.text = todayWeataher?.uv_index
        humidityLabel.text = todayWeataher?.humidity
        
    }
    
//MARK:- 根据天气获得对应图片名
    func checkWeatherImage(name: String) -> String {
        switch name {
        case "晴转多云":
            return "cloudy"
        case "多云转晴":
            return "sun"
        case "晴":
            return "sun"
        case "阴":
            return "yin"
        case "雪":
            return "snow"
        case "雾":
            return "fog"
        case "阵雨":
            return "zhenyu"
        case "雷阵雨":
            return "leizhenyu"
        default:
            return "sun"
        }
    }
    
}


//MARK:- 实现collectionView协议

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeatherCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekWeatherCell", for: indexPath) as! WeatherCollectionCell
        let model = futureArray[indexPath.row]
        cell.configCell(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.size.height)
    }
    
}

