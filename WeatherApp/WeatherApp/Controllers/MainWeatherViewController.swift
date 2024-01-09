//
//  MainWeatherViewController.swift
//  WeatherApp
//
//  Created by Monikaa on 29/12/23.
//

import UIKit
import CoreLocation

class MainWeatherViewController: UIViewController {
    // MARK: outlets
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempMinMaxLabel: UILabel!
    @IBOutlet weak var forcastCollectionView: UICollectionView!
    // MARK: local Variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var webServiceManager = WebServiceManager()
    var currentWeatherData: CurrentWeather?
    var weatherForcastData: [List]?
    
    let kCellConstant = 5
    var latitude =  ""
    var longitude =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UICollectionView Delegates
        self.forcastCollectionView.delegate = self
        self.forcastCollectionView.dataSource = self
        
        // Register XIB Cell
        forcastCollectionView.register(UINib(nibName: XIBConstant.forcastCell, bundle: nil), forCellWithReuseIdentifier: XIBConstant.forcastCell)
        
        //CLLocationManager Delegate
        locationManager.delegate = self
        hasLocationPermission()
        locationManager.requestWhenInUseAuthorization()
        
        //Initial UI Setup
        setupUI()
    }
    
    func hasLocationPermission() {
        let manager = CLLocationManager()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: Update UI for Current Weather
    func updateCurrentWeatherUI() {
        DispatchQueue.main.async {
            if let currentTemp = self.currentWeatherData?.main?.temp {
                let celius = Common.convertTemp(temp: currentTemp, from: .kelvin, to: .celsius)
                self.currentTempLabel.text = celius
            }
            let maxTemp = self.currentWeatherData?.main?.tempMax ?? 0
            let maxCelius = Common.convertTemp(temp: maxTemp, from: .kelvin, to: .celsius)
            let minTemp = self.currentWeatherData?.main?.tempMin ?? 0
            let minCelius = Common.convertTemp(temp: minTemp, from: .kelvin, to: .celsius)
            self.tempMinMaxLabel.text = "H: \(maxCelius)   L: \(minCelius)"
            self.descriptionLabel.text = self.currentWeatherData?.weather?[0].main
            self.currentLocationLabel.text = self.currentWeatherData?.name?.uppercased()
        }
    }
    
    // MARK: Call Current Weather API
    func currentWeatherAPICall() {
        let url = ApiConstant.baseweatherURL + ApiConstant.currentWeatherEndPoint + "lat=\(self.latitude)&lon=\(self.longitude)&appid=" + ApiConstant.apiKey
        webServiceManager.getRequestData(urlString: url, httpMethod: HttpMethod.get, responseModel: CurrentWeather.self) { result in
            switch result {
            case .success(let response):
                self.currentWeatherData = response
                self.updateCurrentWeatherUI()
            case .failure(_):
                self.alertPopUpView()
            }
        }
    }
    
    // MARK: Call Weather Forecast API
    func weatherForcastAPICall() {
        let url = ApiConstant.baseweatherURL + ApiConstant.fiveDayForecastEndpoint + "lat=\(self.latitude)&lon=\(self.longitude)&appid=" + ApiConstant.apiKey
        webServiceManager.getRequestData(urlString: url, httpMethod: HttpMethod.get, responseModel: WeatherForcast.self) { result in
            switch result {
            case .success(let response):
                let weatherForcast = response
                let hourStr = Common.getHours(dateString: weatherForcast.list.first?.dtTxt ?? "")
                self.weatherForcastData = (weatherForcast.list.filter({ list in
                    return list.dtTxt?.contains(hourStr) ?? false
                }))
                DispatchQueue.main.async {
                    self.forcastCollectionView.reloadData()
                }
            case .failure(_):
                self.alertPopUpView()
            }
        }
    }
    
    // MARK: Create a pop-up for Alert
    func alertPopUpView() {
        let alert = UIAlertController(title: Constant.alert, message: Constant.alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constant.ok, style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func setupUI() {
        view.applyGradient()
    }
}

//MARK: - CLLocationManagerDelegate
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            latitude = String(format: "%.1f", manager.location?.coordinate.latitude ?? 0)
            longitude = String(format: "%.1f", manager.location?.coordinate.longitude ?? 0)
            currentWeatherAPICall()
            weatherForcastAPICall()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = String(format: "%.1f", manager.location?.coordinate.latitude ?? 0)
        longitude = String(format: "%.1f", manager.location?.coordinate.longitude ?? 0)
        weatherForcastAPICall()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kCellConstant
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIBConstant.forcastCell, for: indexPath) as! ForcastCell
        guard let weatherforecast = weatherForcastData?[indexPath.row] else  { return cell }
        if let temperature = weatherforecast.main.temp  {
            let celius = Common.convertTemp(temp: temperature, from: .kelvin, to: .celsius)
            cell.temperatureLabel.text = celius
        }
        let day = Common.getDay(dateString: weatherforecast.dtTxt ?? "")
        cell.dayLabel.text = day
        let weatherIcon = weatherforecast.weather[0].icon ?? ""
        let weatherIconStr = ApiConstant.weatherIconURL + weatherIcon + ApiConstant.weatherIconEndPoint
        cell.weatherIcon.imageFromURL(urlString: weatherIconStr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 145)
    }
    
}

