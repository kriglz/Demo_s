import SpriteKit

public class ActionLayer: CALayer {
    
    private let actionDuration = 0.1
        
    func moveAction(by translationLength: CGFloat, actionIndex: Int) {
        Timer.scheduledTimer(withTimeInterval: Double(actionIndex) * actionDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.position.y += translationLength
        }
    }
}
