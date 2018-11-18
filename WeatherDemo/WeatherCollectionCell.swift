//
//  WeatherCollectionCell.swift
//  WeatherDemo
//
//  Created by  mshen on 2018/11/16.
//  Copyright © 2018年 enhance. All rights reserved.
//

import UIKit

class WeatherCollectionCell: UICollectionViewCell {
    
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    func configCell(model: FutureWeather) {
        weekLabel.text = model.week
        tempLabel.text = model.temperature
        imageView.image =  UIImage.init(named:self.checkWeatherImage(name: model.temperature ?? "") )
    }
    
    func checkWeatherImage(name: String) -> String {
        switch name {
        case "晴转多云":
            return "cloudy_s"
        case "多云转晴":
            return "sun_s"
        case "晴":
            return "sun_s"
        case "阴":
            return "yin_s"
        case "雪":
            return "snow_s"
        case "雾":
            return "fog_s"
        case "阵雨":
            return "zhenyu_s"
        case "雷阵雨":
            return "leizhenyu_s"
        default:
            return "sun_s"
        }
    }
}
