//
//  WeatherData.swift
//  Clima
//
//  Created by Диас Сайынов on 23.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}

struct Wind: Codable{
    let speed: Double
}
