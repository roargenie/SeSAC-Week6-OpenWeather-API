

import UIKit

class WeatherImageView: UIView {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "WeatherImageView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        
    }
    
    
}
