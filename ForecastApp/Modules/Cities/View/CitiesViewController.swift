//
//  CitiesViewController.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import UIKit
import CoreData
import SwipeCellKit

class CitiesViewController: UIViewController {
    weak var delegate: CitiesViewModelDelegate?
    private var viewModel: CitiesViewModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityArrayDB = [LocationModelPermanent]()

    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    var background = "sun.background"

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "sun.background")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = .flexibleHeight
        view.showsHorizontalScrollIndicator = true
        view.bounces = true
        return view
    }()
    
    lazy var citiesTableView: UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = .clear
        tableV.translatesAutoresizingMaskIntoConstraints = false
        tableV.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CitiesViewModel()
        setupView()
        configureNavigationBar()
        cityArrayDB = viewModel?.loadLocations() ?? []
        citiesTableView.reloadData()
    }
    
    func setupView() {
        //Background
        backgroundImageView.image = UIImage(named: background)
        view.addSubview(backgroundImageView)

        //Table View
        view.addSubview(citiesTableView)
        citiesTableView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        citiesTableView.setHeight(view.frame.height)
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "City List"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(searchCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backBtnPressed))
    }
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchCity() {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        self.present(UINavigationController(rootViewController: searchViewController), animated: true, completion: nil)
    }
}

//MARK: - TableView Functions
extension CitiesViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArrayDB.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        cell.configureCell(city: cityArrayDB[indexPath.row].place!)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 70
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.passCity(city: cityArrayDB[indexPath.row])
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.viewModel?.deleteCity(index: indexPath.row)
            self.cityArrayDB.remove(at: indexPath.row)
            self.viewModel?.saveLocation()
        }

        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
}

//MARK: - Delegates
extension CitiesViewController: SearchViewControllerDelegate {
    func addCity(city: LocationModelPermanent) {
        self.dismiss(animated: true) {
            self.viewModel?.appendCity(city: city)
            if (self.viewModel?.countCities())! > 5 {
                self.viewModel?.deleteCity(index: 0)
            }
            self.viewModel?.saveLocation()
            self.cityArrayDB = self.viewModel?.loadLocations() ?? []
            self.citiesTableView.reloadData()
        }
    }
}
