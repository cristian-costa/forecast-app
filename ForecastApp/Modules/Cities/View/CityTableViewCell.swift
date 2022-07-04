//
//  CityTableViewCell.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import UIKit
import SwipeCellKit

class CityTableViewCell: SwipeTableViewCell {
    static let identifier = "ReusableCityCell"

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        cityLabel.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 15, paddingRight: 15)
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
