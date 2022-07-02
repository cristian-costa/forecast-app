//
//  HourlyCollectionViewCell.swift
//  ForecastApp
//
//  Created by Cristian Costa on 02/07/2022.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReusableHourlyCell"
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.text = "23 PM"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sun.max")
        return image
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "26º"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .clear
        
        //Hour Label
        addSubview(hourLabel)
        hourLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 10)
        
        //Weather Icon
        addSubview(weatherIcon)
        weatherIcon.setDimensions(height: 50, width: 50)
        weatherIcon.centerY(inView: self)
        weatherIcon.centerX(inView: self)
        
        //Temp Label
        addSubview(tempLabel)
        tempLabel.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 10)
    }
    
    func configureCell(hourModel: HourlyModel, timezone: Int, sunrise: Date, sunset: Date) {
        DispatchQueue.main.async { [weak self] in
            //Hour
            let GMT = 3600
            let hoursGMT = timezone / GMT
            
            let date = hourModel.getTime(timezone: timezone)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            formatter.timeZone = TimeZone(secondsFromGMT: timezone)
            let hour = formatter.string(from: date)
            
            var dateComponentsHourly = DateComponents()
            dateComponentsHourly.hour = hoursGMT
            let dateHourly = Calendar.current.date(byAdding: .hour, value: hoursGMT, to: date)
            
            if Int(hour)! >= 0 && Int(hour)! <= 9 {
                self?.hourLabel.text = "\(hour) AM"
            } else if Int(hour)! >= 10 && Int(hour)! <= 11 {
                self?.hourLabel.text = "\(hour) AM"
            } else {
                self?.hourLabel.text = "\(hour) PM"
            }
            
            //Temp
            let temp = hourModel.temperatureHourlyString()
            self?.tempLabel.text = "\(temp)º"
            
            //Image
            var sunrise = Calendar.current.date(byAdding: .hour, value: hoursGMT, to: sunrise)
            let sunset = Calendar.current.date(byAdding: .hour, value: hoursGMT, to: sunset)
            sunrise = Calendar.current.date(byAdding: .day, value: 1, to: sunrise!)

            self?.weatherIcon.image = UIImage(named: hourModel.conditionName())
            
            if hourModel.conditionName() == "sun.max" {
                if dateHourly! > sunset! && dateHourly! < sunrise! {
                    self?.weatherIcon.image = UIImage(named: "moon.full")
                }
            }
        }
    }
}
