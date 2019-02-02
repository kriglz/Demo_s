import SpriteKit

public class ActionLayer: CALayer {
    
    // MARK: - Properties
        
    // MARK: - Animation
    
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(actionIndex)) { [weak self] in
            self?.frame.origin.x += translationLength
        }
    }
}
