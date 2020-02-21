import UIKit

class Cell: UICollectionViewCell {
    
    static let identifier = "CellIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.random
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension UIColor {
    
    static var random: UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.5...1)
        let brightness = CGFloat.random(in: 0.5...1)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
