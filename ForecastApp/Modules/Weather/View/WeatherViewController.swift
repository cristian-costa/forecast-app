//
//  WeatherViewController.swift
//  ForecastApp
//
//  Created by Cristian Costa on 01/07/2022.
//

import UIKit
import MapKit
import CoreLocation

class WeatherViewController: UIViewController {
    private var viewModel: WeatherViewModel?
    private var locationManager = CLLocationManager()
    var weatherObj = WeatherModel()
    var hourlyArr = [HourlyModel]()
    var dailyArr = [DailyModel]()

    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = .flexibleHeight
        view.showsHorizontalScrollIndicator = true
        view.bounces = true
        return view
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "sun.background")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let conditionWeatherLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let firstView: UIView = {
        let view = UIView()
        view.setHeight(200)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    private let maxLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let minLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 80, weight: .light)
        return label
    }()
    
    private let symbolTemp: UILabel = {
        let label = UILabel()
        label.text = "º"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 80, weight: .light)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "- - - -"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.layer.cornerRadius = 20
        return map
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.setHeight(1)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.setHeight(1)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    private let separatorView3: UIView = {
        let view = UIView()
        view.setHeight(1)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var collectionViewDaily: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        collectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var collectionViewHourly: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        viewModel?.delegate = self
        configureNavigationBar()
        setupView()
    }

    private func updateMap(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
        let region = MKCoordinateRegion(center: location, span: span)
        let pin = MKPointAnnotation()
        pin.coordinate = location
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pin)
    }
}

//MARK: - View Functions
extension WeatherViewController {
    func setupView() {
        //Set Background
        view.addSubview(backgroundImageView)
        
        //Scroll View
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        //Condition Label
        scrollView.addSubview(conditionWeatherLabel)
        conditionWeatherLabel.centerX(inView: scrollView)
        conditionWeatherLabel.anchor(top: scrollView.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        //First View (labelTemp, symbolTemp, maxLabel, minLabel, dateLabel)
        scrollView.addSubview(firstView)
        firstView.anchor(top: conditionWeatherLabel.topAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 30, paddingLeft: 50, paddingRight: 50)
        firstView.centerX(inView: scrollView)
        
        //Label Temp
        firstView.addSubview(tempLabel)
        tempLabel.centerX(inView: firstView)
        tempLabel.centerY(inView: firstView)
        
        firstView.addSubview(symbolTemp)
        symbolTemp.centerY(inView: firstView)
        symbolTemp.anchor(left: tempLabel.rightAnchor)
        
        //Max Label
        firstView.addSubview(maxLabel)
        maxLabel.anchor(top: firstView.topAnchor, left: firstView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        //Min Label
        firstView.addSubview(minLabel)
        minLabel.anchor(top: firstView.topAnchor, right: firstView.rightAnchor, paddingTop: 10, paddingRight: 20)
        
        //Date Label
        firstView.addSubview(dateLabel)
        dateLabel.centerX(inView: firstView)
        dateLabel.anchor(bottom: firstView.bottomAnchor, paddingBottom: 15)
        
        //Map
        scrollView.addSubview(mapView)
        mapView.centerX(inView: scrollView)
        mapView.anchor(top: firstView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 30, paddingLeft: 50, paddingRight: 50)
        mapView.setHeight(200)
        
        //Separator
        scrollView.addSubview(separatorView)
        separatorView.centerX(inView: scrollView)
        separatorView.anchor(top: mapView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        //Humidity
        scrollView.addSubview(humidityLabel)
        humidityLabel.anchor(top: separatorView.topAnchor, left: scrollView.leftAnchor, paddingTop: 15, paddingLeft: 30)
        
        //Other Label
        scrollView.addSubview(pressureLabel)
        pressureLabel.anchor(top: separatorView.topAnchor, right: scrollView.rightAnchor, paddingTop: 15, paddingRight: 30)
        
        //Separator
        scrollView.addSubview(separatorView2)
        separatorView2.centerX(inView: scrollView)
        separatorView2.anchor(top: humidityLabel.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0)
        
        //Daily Collection View
        scrollView.addSubview(collectionViewDaily)
        collectionViewDaily.anchor(top: separatorView2.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 10)
        collectionViewDaily.setHeight(70)
        
        //Separator
        scrollView.addSubview(separatorView3)
        separatorView3.centerX(inView: scrollView)
        separatorView3.anchor(top: collectionViewDaily.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        //Hourly Collection View
        scrollView.addSubview(collectionViewHourly)
        collectionViewHourly.anchor(top: separatorView3.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 10)
        collectionViewHourly.setHeight(140)
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Mi ubicacion"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(showCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(fetchLocation))
    }
    
    @objc func fetchLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        navigationItem.title = "Mi ubicacion"
    }
    
    @objc func showCity() {
        let citiesViewController = CitiesViewController()
        citiesViewController.delegate = self
        self.navigationController?.pushViewController(citiesViewController, animated: true)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            viewModel?.fetch(latitude: location.coordinate.latitude, longitute: location.coordinate.longitude)
            self.updateMap(latitude: location.coordinate.latitude, longitute: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location.")
    }
}

//MARK: - Collection View Funcs
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDaily {
            return dailyArr.count
        } else {
            return hourlyArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDaily {
            let width  = (view.frame.width-20)/2
            return CGSize(width: width, height: 70)
        } else {
            let width = (view.frame.width-20)/5
            return CGSize(width: width, height: 140)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDaily {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as? DailyCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(day: dailyArr[indexPath.row], timezone: weatherObj.getTimezone())
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(hourModel: hourlyArr[indexPath.row], timezone: weatherObj.getTimezone(), sunrise: weatherObj.getTimeSunrise(), sunset: weatherObj.getTimeSunset())
            return cell
        }
    }
}

//MARK: - WeatherViewModelDelegate
extension WeatherViewController: WeatherViewModelDelegate {
    func fetchWeatherSuccess(weather: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherObj = weather
            let hourlyArray = weather.hourly!
            self?.dailyArr = weather.daily!
            self?.hourlyArr = Array(hourlyArray.prefix(24))
            self?.conditionWeatherLabel.text = weather.getCurrentDescription().capitalized
            self?.maxLabel.text = "Máx: \(weather.daily![0].maxTemperatureString())"
            self?.minLabel.text = "Mín: \(weather.daily![0].minTemperatureString())"
            self?.tempLabel.text = "\(weather.getCurrentTemp())"
            self?.dateLabel.text = self?.viewModel?.getCurrentDate(timeZone: weather.getTimezone())
            self?.humidityLabel.text = "Húmedad: \(weather.getCurrentHumidity())%"
            self?.pressureLabel.text = "Presión: \(weather.getCurrentPressure())"
            
            
            self?.collectionViewHourly.reloadData()
            self?.collectionViewDaily.reloadData()
        }
    }
    
    func fetchWeatherError() {
        DispatchQueue.main.async {
            print("Error !")
        }
    }
}

extension WeatherViewController: CitiesViewModelDelegate {
    func passCity(city: LocationModelPermanent) {
        viewModel?.fetch(latitude:  city.latitude, longitute: city.longitude)
        updateMap(latitude: city.latitude, longitute: city.longitude)
        navigationItem.title = city.place
    }
}
