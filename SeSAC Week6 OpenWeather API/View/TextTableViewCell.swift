

import UIKit

class TextTableViewCell: UITableViewCell {
    
    static let identifier = "TextTableViewCell"
    
    @IBOutlet weak var contentLableView: ContentLableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLableView.contentLabel.layer.cornerRadius = 10
        contentLableView.contentLabel.clipsToBounds = true
        contentLableView.isHidden = false
        
        self.backgroundColor = .clear
    }
    
    func setUI(text: String) {
        contentLableView.contentLabel.text = " \(text) "
        
    }
    
    
}
