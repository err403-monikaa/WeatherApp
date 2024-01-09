//
//  Constant.swift
//  WeatherApp
//
//  Created by Monikaa on 29/12/23.
//

import Foundation

//MARK: - WebServiceConstant
enum WebServiceConstant {
    static let applicationJSON = "application/json"
    static let contentType = "Content-Type"
}

//MARK: - NetworkError
enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
}

//MARK: - HttpMethod
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

//MARK: - ApiConstant
enum ApiConstant {
    static let baseweatherURL = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "884b7cd7ec7f224e672719dd241c112d"
    static let currentWeatherEndPoint = "/weather?"
    static let fiveDayForecastEndpoint = "/forecast?"
    static let weatherIconURL = "https://openweathermap.org/img/wn/"
    static let weatherIconEndPoint = "@2x.png"
}
