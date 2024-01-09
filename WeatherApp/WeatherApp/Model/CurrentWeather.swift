//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Monikaa on 31/12/23.
//

import Foundation

//MARK: - CurrentWeather
struct CurrentWeather: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
//    var rain: Rain?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coord = try container.decode(Coord.self, forKey: .coord)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.base = try container.decode(String.self, forKey: .base)
        self.main = try container.decode(Main.self, forKey: .main)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.wind = try container.decode(Wind.self, forKey: .wind)
//        self.rain = try container.decode(Rain.self, forKey: .rain)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.timezone = try container.decode(Int.self, forKey: .timezone)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.cod = try container.decode(Int.self, forKey: .cod)
    }
}

//MARK: - Coord
struct Coord: Codable {
    var lon: Double?
    var lat: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.lat = try container.decode(Double.self, forKey: .lat)
    }
}

//MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.main = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
    }
}

//MARK: - Main
struct Main: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
    }
}

//MARK: - Wind
struct Wind: Codable {
    var speed: Double?
    var deg: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decode(Double.self, forKey: .speed)
        self.deg = try container.decode(Int.self, forKey: .deg)
    }
}

//MARK: - Rain
struct Rain: Codable {
    var perHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case perHour = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.perHour = try container.decode(Double.self, forKey: .perHour)
    }
}

//MARK: - Clouds
struct Clouds: Codable {
    var all: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.all = try container.decode(Int.self, forKey: .all)
    }
}

//MARK: - Sys
struct Sys: Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(Int.self, forKey: .type)
        self.id = try container.decode(Int.self, forKey: .id)
        self.country = try container.decode(String.self, forKey: .country)
        self.sunrise = try container.decode(Int.self, forKey: .sunrise)
        self.sunset = try container.decode(Int.self, forKey: .sunset)
    }
}
