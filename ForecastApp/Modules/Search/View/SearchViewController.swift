//
//  searchViewController.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import UIKit
import CoreData

protocol SearchViewControllerDelegate: AnyObject {
    func addCity(city: LocationModelPermanent)
}

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    var cityArray = [CityModel]()
    private var viewModel: SearchViewModel?
    weak var delegate: SearchViewControllerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var citiesTableView: UITableView = {
        let tableV = UITableView()
//        tableV.separatorStyle = .none
        tableV.backgroundColor = .clear
        tableV.translatesAutoresizingMaskIntoConstraints = false
        tableV.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureNavigationBar()
        
        viewModel = SearchViewModel()
        viewModel?.delegate = self
    }
}

//MARK: - View Functions
extension SearchViewController {
    func setupView() {
        view.backgroundColor = .white
        
        //Search Bar
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        
        //Table View
        view.addSubview(citiesTableView)
        citiesTableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        citiesTableView.setHeight(view.frame.height)
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Search"
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}

//MARK: - UISearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text! == "") {
            cityArray = []
        }
        cityArray = []
        let str = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        viewModel?.fetch(city: str)
        citiesTableView.reloadData()
    }
}

//MARK: - UITableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configureCell(city: cityArray[indexPath.row].getPlace())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityToAdd = cityArray[indexPath.row]
        let cityToAddBD = LocationModelPermanent(context: context)
        cityToAddBD.place = cityToAdd.getPlace()
        cityToAddBD.latitude = cityToAdd.getLat()
        cityToAddBD.longitude = cityToAdd.getLon()
        delegate?.addCity(city: cityToAddBD)
    }
}

//MARK: - SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    func fetchCitySuccess(city: [CityModel]) {
        DispatchQueue.main.async {
            print(city.count)
            if city.count == 0 {
                let alert = UIAlertController(title: "Error", message: "No results found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                for i in 0...city.count-1 {
                    let name = city[i].getPlace()
                    let latitute = city[i].getLat()
                    let longitute = city[i].getLon()
                    let locationObject = CityModel(city: name, long: longitute, lat: latitute)
                    self.cityArray.append(locationObject)
                }
            }
            self.citiesTableView.reloadData()
        }
    }
    
    func fetchCityError() {
        let alert = UIAlertController(title: "Error", message: "We couldn't fetch the city", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
