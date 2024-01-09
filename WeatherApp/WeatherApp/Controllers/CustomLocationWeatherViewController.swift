//
//  CustomLocationWeatherViewController.swift
//  WeatherApp
//
//  Created by Monikaa on 06/01/24.
//

import UIKit
import CoreLocation

class CustomLocationWeatherViewController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempMinMaxLabel: UILabel!
    @IBOutlet weak var weatherImgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var forcastCollectionView: UICollectionView!
    //MARK: local Variables
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
        
        // Button Action
        searchButton.addTarget(self, action: #selector(onClickSearchButton), for: .touchUpInside)
        
        // CLLocationManager Delegate
        locationSearchBar.delegate = self
        
        // Initial UI Setup
        setupUI()
    }
    
    func setupUI() {
        view.applyGradient()
        containerView.isHidden = true
        outerView.isHidden = false
        outerView.backgroundColor = UIColor.clear
        locationSearchBar.layer.cornerRadius = 10
    }
    
    //MARK: Update UI for Current Weather
    func updateCurrentWeatherUI() {
        self.containerView.isHidden = false
        self.outerView.isHidden = true
        let location = self.currentWeatherData?.name ?? ""
        if let temp = self.currentWeatherData?.main?.temp {
            let celius = Common.convertTemp(temp: temp, from: .kelvin, to: .celsius)
            self.locationLabel.text = celius + ", " + location
        }
        let maxTemp = self.currentWeatherData?.main?.tempMax ?? 0
        let maxCelius = Common.convertTemp(temp: maxTemp, from: .kelvin, to: .celsius)
        let minTemp = self.currentWeatherData?.main?.tempMin ?? 0
        let minCelius = Common.convertTemp(temp: minTemp, from: .kelvin, to: .celsius)
        self.tempMinMaxLabel.text = "H: \(maxCelius)   L: \(minCelius)"
        self.descriptionLabel.text = self.currentWeatherData?.weather?[0].main
    }
    
    //MARK: Update UI for Weather Forecast
    func updateForecastUI() {
        DispatchQueue.main.async {
            self.containerView.isHidden = false
            self.outerView.isHidden = true
            self.forcastCollectionView.reloadData()
        }
    }
    
    //MARK: Create a pop-up for Alert
    func alertPopUpView() {
        let alert = UIAlertController(title: Constant.alert, message: Constant.alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constant.ok, style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    //MARK: To get latitude and longitude of given location
    func getCoordinateFrom(cityName: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        CLGeocoder().geocodeAddressString(cityName) { completion($0?.first?.location?.coordinate, $1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Search Button Action
    @objc func onClickSearchButton() {
        self.locationSearchBar.endEditing(true)
        let searchText = locationSearchBar.text ?? ""
        let address = searchText
        getCoordinateFrom(cityName: address ) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            DispatchQueue.main.async {
                self.latitude = String(format: "%.1f", coordinate.latitude)
                self.longitude = String(format: "%.1f", coordinate.longitude)
                self.currentWeatherAPICall()
                self.weatherForcastAPICall()
            }
        }
    }
    
    //MARK: Call Current Weather API
    func currentWeatherAPICall() {
        let url = ApiConstant.baseweatherURL + ApiConstant.currentWeatherEndPoint + "lat=\(self.latitude)&lon=\(self.longitude)&appid=" + ApiConstant.apiKey
        webServiceManager.getRequestData(urlString: url, httpMethod: HttpMethod.get, responseModel: CurrentWeather.self) { result in
            switch result {
            case .success(let response):
                self.currentWeatherData = response
                DispatchQueue.main.async {
                    self.updateCurrentWeatherUI()
                }
            case .failure(_):
                self.alertPopUpView()
            }
        }
    }
    
    //MARK: Call Weather Forecast API
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
                self.updateForecastUI()
            case .failure(_):
                self.alertPopUpView()
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension CustomLocationWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onClickSearchButton()
        self.locationSearchBar.endEditing(true)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CustomLocationWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kCellConstant
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIBConstant.forcastCell, for: indexPath) as! ForcastCell
        guard let weatherForcast = weatherForcastData?[indexPath.row] else { return cell }
        if let temperature = weatherForcast.main.temp  {
            let celius = Common.convertTemp(temp: temperature, from: .kelvin, to: .celsius)
            cell.temperatureLabel.text = celius
        }
        let day = Common.getDay(dateString: weatherForcast.dtTxt ?? "")
        cell.dayLabel.text = day
        let weatherIcon = weatherForcast.weather[0].icon ?? ""
        let weatherIconStr = ApiConstant.weatherIconURL + weatherIcon + ApiConstant.weatherIconEndPoint
        cell.weatherIcon.imageFromURL(urlString: weatherIconStr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 145)
    }
}

