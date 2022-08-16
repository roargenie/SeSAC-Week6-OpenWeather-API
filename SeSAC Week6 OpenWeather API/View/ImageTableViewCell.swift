

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let identifier = "ImageTableViewCell"
    
    @IBOutlet weak var weatherImageView: WeatherImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weatherImageView.weatherImageView.layer.cornerRadius = 10
        weatherImageView.weatherImageView.clipsToBounds = true
        weatherImageView.isHidden = false
        self.backgroundColor = .clear
    }
    
//    func setUI(image: String) {
//
//        let image = URL(string: EndPoint.imageURL + image + "@2x.png")
//
//    }
    
    
    
}
