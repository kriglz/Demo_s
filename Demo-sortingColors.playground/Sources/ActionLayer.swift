import SpriteKit

public class ActionLayer: CALayer {
    
    func moveAction(by translationLength: CGFloat, duration: Double, actionIndex: Int) {
        Timer.scheduledTimer(withTimeInterval: Double(actionIndex) * duration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.position.y += translationLength
        }
    }
}
