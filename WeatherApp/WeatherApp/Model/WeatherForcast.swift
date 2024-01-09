//
//  WeatherForcast5.swift
//  WeatherApp
//
//  Created by Monikaa on 01/01/24.
//

import Foundation

//MARK: -
struct WeatherForcast: Codable {
    var cod: String?
    var message: Int?
    var cnt: Int?
    var list: [List]
    var city: City
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod = try container.decodeIfPresent(String.self, forKey: .cod)
        self.message = try container.decodeIfPresent(Int.self, forKey: .message)
        self.cnt = try container.decodeIfPresent(Int.self, forKey: .cnt)
        self.list = try container.decode([List].self, forKey: .list)
        self.city = try container.decode(City.self, forKey: .city)
    }
}

//MARK: -
struct List: Codable {
    var dt: Int?
    var main: MainData
    var weather: [WeatherData]
    var clouds: CloudsData
    var wind: WindData
    var visibility: Int?
    var pop: Double?
    var sys: SysData
    var dtTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop
        case sys
        case dtTxt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.main = try container.decode(MainData.self, forKey: .main)
        self.weather = try container.decode([WeatherData].self, forKey: .weather)
        self.clouds = try container.decode(CloudsData.self, forKey: .clouds)
        self.wind = try container.decode(WindData.self, forKey: .wind)
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        self.pop = try container.decodeIfPresent(Double.self, forKey: .pop)
        self.sys = try container.decode(SysData.self, forKey: .sys)
        self.dtTxt = try container.decodeIfPresent(String.self, forKey: .dtTxt)
    }
}

//MARK: -
struct City: Codable {
    var id: Int?
    var name: String?
    var coord: CoordData
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.coord = try container.decode(CoordData.self, forKey: .coord)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.population = try container.decodeIfPresent(Int.self, forKey: .population)
        self.timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
        self.sunrise = try container.decodeIfPresent(Int.self, forKey: .sunrise)
        self.sunset = try container.decodeIfPresent(Int.self, forKey: .sunset)
    }
}

//MARK: - CoordData
struct CoordData: Codable {
    var lat: Double?
    var lon: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon)
    }
}

//MARK: - CloudsData
struct CloudsData: Codable {
    var all: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.all = try container.decodeIfPresent(Int.self, forKey: .all)
    }
}

//MARK: - MainData
struct MainData: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var seaLevel: Int?
    var grndLevel: Int?
    var humidity: Int?
    var tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decodeIfPresent(Double.self, forKey: .temp)
        self.feelsLike = try container.decodeIfPresent(Double.self, forKey: .feelsLike)
        self.tempMin = try container.decodeIfPresent(Double.self, forKey: .tempMin)
        self.tempMax = try container.decodeIfPresent(Double.self, forKey: .tempMax)
        self.pressure = try container.decodeIfPresent(Int.self, forKey: .pressure)
        self.seaLevel = try container.decodeIfPresent(Int.self, forKey: .seaLevel)
        self.grndLevel = try container.decodeIfPresent(Int.self, forKey: .grndLevel)
        self.humidity = try container.decodeIfPresent(Int.self, forKey: .humidity)
        self.tempKf = try container.decodeIfPresent(Double.self, forKey: .tempKf)
    }
}

//MARK: - RainData
struct RainData: Codable {
    var threeHours: Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.threeHours = try container.decodeIfPresent(Double.self, forKey: .threeHours)
    }
}

//MARK: - SysData
struct SysData: Codable {
    var pod: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pod = try container.decodeIfPresent(String.self, forKey: .pod)
    }
}

//MARK: - WeatherData
struct WeatherData: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.main = try container.decodeIfPresent(String.self, forKey: .main)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
}

//MARK: - WindData
struct WindData: Codable {
    var speed: Double?
    var deg: Int?
    var gust: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        self.deg = try container.decodeIfPresent(Int.self, forKey: .deg)
        self.gust = try container.decodeIfPresent(Double.self, forKey: .gust)
    }
}


