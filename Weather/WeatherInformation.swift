//
//  WeatherInformation.swift
//  Weather
//
//  Created by 김원기 on 2022/08/27.
//



// 현재 날씨를 저장할 수 있는 구조체 생성

import Foundation


// Codable은 자신을 변환하거나 외부 표현으로 변환할 수 있는 타입 (json)
// json <-> codable 서로 인코딩과 디코딩이 가능해진다

struct WeatherInformation: Codable {
    let weather: [Weather]
    
    // json의 메인키와 매핑 되어야 하기 때문에 coding keys 다시 선언
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// json 데이터의 키와 이름이 달라도 매핑될 수 있도록 coding keys라는 스트링 타입의 열거형을 선언하고 프로토콜을 준수하는 방법으로 사용
struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

