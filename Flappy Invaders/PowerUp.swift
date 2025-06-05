import Foundation
import SpriteKit

class PowerUp: SKSpriteNode {

    init(sceneSize: CGSize) {
        let texture = SKTexture(imageNamed: "powerup")
        let size = CGSize(width: 40, height: 40)
        super.init(texture: texture, color: .clear, size: size)

        let randomY = CGFloat.random(in: 0 ..< sceneSize.height)
        self.position = CGPoint(x: sceneSize.width - 80, y: randomY)
        
        setupPhysics()

        let duration = CGFloat.random(in: 8...12)
        let move = SKAction.move(to: CGPoint(x: -self.size.width, y: self.position.y), duration: TimeInterval(duration))
        self.run(SKAction.sequence([move, SKAction.removeFromParent()]))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Categoria.powerUp
        self.physicsBody?.contactTestBitMask = Categoria.player
        self.physicsBody?.collisionBitMask = Categoria.none
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}

class AmmoBox: PowerUp {
    
    override init(sceneSize: CGSize) {
        super.init(sceneSize: sceneSize)
        self.texture = SKTexture(imageNamed: "ammo box")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class Slow: PowerUp {
    
    override init(sceneSize: CGSize) {
        super.init(sceneSize: sceneSize)
        self.texture = SKTexture(imageNamed: "slow")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
