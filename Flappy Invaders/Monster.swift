//
//  Monster.swift
//  Flappy Invaders
//
//  Created by Aluno Tmp on 16/05/2025.
//

import Foundation
import SpriteKit

class Monster: SKSpriteNode {
    
    init(sceneSize: CGSize, killed: Int) {
        let texture = SKTexture(imageNamed: "monster")
        let size = CGSize(width: 50, height: 50)
        super.init(texture: texture, color: .clear, size: size)

        let randomY = CGFloat.random(in: 0 ..< sceneSize.height)
        self.position = CGPoint(x: sceneSize.width - 80, y: randomY)
        
        setupPhysics()
        
        // Determinar a duração com base em 'killed'
        var i: CGFloat = 10
        var j: CGFloat = 10
        switch killed {
        case 0 ..< 3:
            i = 10
            j = 10
        case 3 ..< 6:
            i = 8
        case 6 ..< 9:
            i = 6
        case 9 ..< 12:
            i = 4
            j = 7
        default:
            i = 2
        }

        let duration = CGFloat.random(in: i ... j)
        let move = SKAction.move(to: CGPoint(x: -self.size.width, y: self.position.y), duration: TimeInterval(duration))
        self.run(SKAction.sequence([move, SKAction.removeFromParent()]))
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
}

class FastMonster : Monster {
    override init(sceneSize: CGSize, killed: Int) {
            super.init(sceneSize: sceneSize, killed: killed)
            self.texture = SKTexture(imageNamed: "fastMonster")
            self.size = CGSize(width: 40, height: 40)
        
        var i: CGFloat = 10
        var j: CGFloat = 10
        switch killed {
        case 0 ..< 3:
            i = 8
            j = 8
        case 3 ..< 6:
            i = 5
        case 6 ..< 9:
            i = 4
        case 9 ..< 12:
            i = 2
            j = 5
        default:
            i = 1
        }

        let duration = CGFloat.random(in: i ... j)
        let move = SKAction.move(to: CGPoint(x: -self.size.width, y: self.position.y), duration: TimeInterval(duration))
        self.run(SKAction.sequence([move, SKAction.removeFromParent()]))
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
}
