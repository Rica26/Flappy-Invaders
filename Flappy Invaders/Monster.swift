import Foundation
import SpriteKit

class Monster: SKSpriteNode {
    var speedPerSecond: CGFloat = 100
    private var lastUpdateTime: TimeInterval = 0
    var hp: Int = 1
    init(sceneSize: CGSize, killed: Int) {
        let texture = SKTexture(imageNamed: "monster")
        let size = CGSize(width: 50, height: 50)
        
        
        super.init(texture: texture, color: .clear, size: size)

        let randomY = CGFloat.random(in: 0 ..< sceneSize.height)
        self.position = CGPoint(x: sceneSize.width - 80, y: randomY)
        self.xScale = -1
        
        setupPhysics()
        configureSpeed(killed: killed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Categoria.monster
        self.physicsBody?.contactTestBitMask = Categoria.projectile | Categoria.player
        self.physicsBody?.collisionBitMask = Categoria.none
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    func configureSpeed(killed: Int) {
        switch killed {
        case 0 ..< 15:
            speedPerSecond = 100
        case 15 ..< 30:
            speedPerSecond = 120
        case 30 ..< 45:
            speedPerSecond = 150
        case 45 ..< 60:
            speedPerSecond = 180
        default:
            speedPerSecond = 220
        }
        
    }

    func update(deltaTime: TimeInterval) {
        let distance = speedPerSecond * CGFloat(deltaTime)
        self.position.x -= distance
    }

    func slowDown() {
        speedPerSecond *= 0.5
    }
    
    func takeHit() {
        hp -= 1

        if hp <= 0 {
            self.removeFromParent()
        }
    }

}

class FastMonster: Monster {
    override init(sceneSize: CGSize, killed: Int) {
        super.init(sceneSize: sceneSize, killed: killed)
        self.texture = SKTexture(imageNamed: "fastMonster")
        self.size = CGSize(width: 40, height: 40)

        switch killed {
        case 0 ..< 15:
            speedPerSecond = 150
        case 15 ..< 30:
            speedPerSecond = 180
        case 30 ..< 45:
            speedPerSecond = 200
        case 45 ..< 60:
            speedPerSecond = 230
        default:
            speedPerSecond = 270
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class LargeMonster: Monster {
    override init(sceneSize: CGSize, killed: Int) {
        super.init(sceneSize: sceneSize, killed: killed)
        self.texture = SKTexture(imageNamed: "largeMonster") // Certifica-te de que esta imagem existe
        self.size = CGSize(width: 80, height: 80)
        self.hp = 3

        speedPerSecond = 85
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
