//
//  CityTableViewCell.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    static let identifier = "ReusableCityCell"

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        
        //City Label
        addSubview(cityLabel)
        cityLabel.anchor(left: self.leftAnchor, paddingLeft: 15)
        cityLabel.centerY(inView: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(city: String) {
        DispatchQueue.main.async { [weak self] in
            self?.cityLabel.text = city
        }
    }

}
