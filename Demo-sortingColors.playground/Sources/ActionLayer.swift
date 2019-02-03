import SpriteKit

public class ActionLayer: CALayer {
    
    // MARK: - Properties
    
    private let animationDuration = 0.1
    
    // MARK: - Animation
    
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration * Double(actionIndex)) { [weak self] in
            guard let self = self else { return }
            self.frame.origin.x += translationLength
        }
    }
}
