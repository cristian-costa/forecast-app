//
//  DailyCollectionViewCell.swift
//  ForecastApp
//
//  Created by Cristian Costa on 02/07/2022.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReusableDailyCell"

    var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sun.max")
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Vie 1 de jul"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let maxLabel: UILabel = {
        let label = UILabel()
        label.text = "Max: 26º"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let minLabel: UILabel = {
        let label = UILabel()
        label.text = "Min: 13º"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .clear
        
        //Weather Icon
        addSubview(weatherIcon)
        weatherIcon.setDimensions(height: 50, width: 50)
        weatherIcon.anchor(left: contentView.leftAnchor, paddingTop: 10)
        weatherIcon.centerY(inView: self)
        
        //Date Label
        addSubview(dateLabel)
        dateLabel.anchor(top: self.topAnchor, left: weatherIcon.rightAnchor, right: self.rightAnchor, paddingTop: 10)

        //Max
        addSubview(maxLabel)
        addSubview(minLabel)
        maxLabel.anchor(left: weatherIcon.rightAnchor, bottom: self.bottomAnchor, right: minLabel.leftAnchor, paddingLeft: 10, paddingBottom: 10)
        minLabel.anchor(left: maxLabel.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 10, paddingRight: 10)

    }
    
    func configureCell(day: DailyModel, timezone: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherIcon.image = UIImage(named: day.conditionName())
            self?.dateLabel.text = day.getTime(timezoneGMT: timezone)
            self?.minLabel.text = "Min: \(day.minTemperatureString())"
            self?.maxLabel.text = "Max: \(day.maxTemperatureString())"
        }
    }
}
