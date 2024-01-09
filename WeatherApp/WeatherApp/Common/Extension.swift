//
//  Extension.swift
//  WeatherApp
//
//  Created by Monikaa on 07/01/24.
//

import Foundation
import UIKit

//MARK: - UIView
extension UIView {
    func applyGradient() {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        
        // Set the colors for the gradient layer
        let primaryColor = UIColor(red: 31/255, green: 29/255, blue: 71/255, alpha: 1).cgColor
        let secondaryColor = UIColor.white.cgColor
        gradientLayer.colors = [primaryColor, secondaryColor]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Set the frame for the gradient layer
        gradientLayer.frame = self.frame
        
        //Add the gradient layer as a sublayer to the background view
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.7
        self.layer.borderColor = UIColor.black.cgColor
    }
}

//MARK: - UIImageView
extension UIImageView {
    func imageFromURL(urlString: String) {
        // Create URL
        guard let url = URL(string: urlString) else { return }
        
        // Create URLRequest
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                // Create Image and Update Image View
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}
