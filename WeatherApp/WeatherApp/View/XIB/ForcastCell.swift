//
//  ForcastCell.swift
//  WeatherApp
//
//  Created by Monikaa on 05/01/24.
//

import UIKit

class ForcastCell: UICollectionViewCell {
    
    @IBOutlet weak var forcastView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.setCornerRadius(radius: 25)
    }
    
}
