import UIKit

public struct Color {
    
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.r = r / 255
        self.g = g / 255
        self.b = b / 255
    }
    
    static func gradientColor(_ color1: Color, _ color2: Color, percentage: CGFloat) -> UIColor {
        let red = color1.r + (color2.r - color1.r) * percentage
        let green = color1.g + (color2.g - color1.g) * percentage
        let blue = color1.b + (color2.b - color1.b) * percentage
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
