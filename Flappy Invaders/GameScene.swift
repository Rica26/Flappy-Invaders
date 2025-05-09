//
//  GameScene.swift
//  Ninjas
//
//  Created by Daniela Da Cruz on 11/04/2025.
//

import SpriteKit
import GameplayKit

struct Categoria {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let monster : UInt32 = 0b1  // 1
    static let projectile : UInt32 = 0b10 // 2
    static let player : UInt32 = 0b11 // 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "player")
    var lives = 3
    var killed = 0
    let labelPlayer = SKLabelNode()
    let labelMonsters = SKLabelNode()
    
    let upButton = SKSpriteNode(imageNamed: "arrow")
    let downButton = SKSpriteNode(imageNamed: "arrow")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.size = self.size
            background.zPosition = -1
            addChild(background)
        
        player.position = CGPoint(x: size.width * 0.05,
                                  y: size.height * 0.5)
        player.size = CGSize(width: 50, height: 50)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = Categoria.player
        player.physicsBody?.contactTestBitMask = Categoria.monster
        player.physicsBody?.collisionBitMask = Categoria.none
        
        
        labelPlayer.text = "Lives: \(lives)"
        labelPlayer.fontSize = 30
        labelPlayer.fontColor = .red
        labelPlayer.position = CGPoint(x: 100, y: size.height - 50)
        addChild(labelPlayer)
        
        
        labelMonsters.text = "Killed: \(killed)"
        labelMonsters.fontSize = 30
        labelMonsters.fontColor = .red
        labelMonsters.position = CGPoint(x: size.width - 100, y: size.height - 50)
        addChild(labelMonsters)
        
        // fisica
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1)
            ]
                             )))
        
        
        let bgMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
        
        // Configura o botão de cima
        upButton.name = "upButton"
        upButton.size = CGSize(width: 70, height: 70)
        upButton.position = CGPoint(x: size.width - 60, y: 100)
        addChild(upButton)
            
        // Configura o botão de baixo
        downButton.name = "downButton"
        downButton.size = CGSize(width: 70, height: 70)
        downButton.position = CGPoint(x: size.width - 60, y: 40)
        downButton.zRotation = .pi
        addChild(downButton)
    }
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        let randomY = CGFloat.random(in: monster.size.height/2 ..< size.height - monster.size.height/2)
        monster.position = CGPoint(x: size.width - 80, y: randomY)
        monster.size = CGSize(width: 50, height: 50)
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = false
        monster.physicsBody?.categoryBitMask = Categoria.monster
        monster.physicsBody?.contactTestBitMask = Categoria.projectile | Categoria.player
        monster.physicsBody?.collisionBitMask = Categoria.none
        monster.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(monster)
        
        let duration = CGFloat.random(in: 2 ..< 4)
        let move = SKAction.move(to: CGPoint(x: -monster.size.width, y: randomY), duration: duration)
        monster.run(SKAction.sequence([move, SKAction.removeFromParent()] ))
        
    }
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        projectile.size = CGSize(width: 20, height: 20)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = Categoria.projectile
        projectile.physicsBody?.contactTestBitMask = Categoria.monster
        projectile.physicsBody?.collisionBitMask = Categoria.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        if offset.x < 0 { return }
        addChild(projectile)
        
        //let direction = offset.normalized()
        let direction = CGVector(dx: cos(player.zRotation), dy: sin(player.zRotation))
        let amount = direction * CGVector(dx:1000, dy:1000) // fora do ecra
        let finalDestination = amount + projectile.position
        let move = SKAction.move(to: finalDestination, duration: 2)
        
        
        // Calcula o vetor de direção com base na rotação do jogador
        
        // Aplica impulso ao projétil
        let speed: CGFloat = 500
        let impulse = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
        projectile.physicsBody?.applyImpulse(impulse)
        let moveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([move, moveDone]))
        
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    }
    */
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }

        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        projectile.size = CGSize(width: 50, height: 50)

        // Define física do projétil
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = Categoria.projectile
        projectile.physicsBody?.contactTestBitMask = Categoria.monster
        projectile.physicsBody?.collisionBitMask = Categoria.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        addChild(projectile)

        // Direção baseada na rotação do jogador
        let direction = CGVector(dx: cos(player.zRotation), dy: sin(player.zRotation))

        // Aplica impulso ao projétil
        let speed: CGFloat = 500
        let impulse = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
        projectile.physicsBody?.applyImpulse(impulse)

        // Remove o projétil após 2 segundos
        let remove = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()])
        projectile.run(remove)

        // Som do disparo
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    }


    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == Categoria.monster &&
            secondBody.categoryBitMask == Categoria.projectile {
            if let monster = firstBody.node as? SKSpriteNode,
               let projectile = secondBody.node as? SKSpriteNode {
                projectile.removeFromParent()
                monster.removeFromParent()
                
                killed += 1
                labelMonsters.text = "Killed: \(killed)"
                if killed > 499 {
                    changeScene(won: true)
                }
            }
        }
        else if firstBody.categoryBitMask == Categoria.monster &&
                    secondBody.categoryBitMask == Categoria.player {
            lives -= 1
            labelPlayer.text = "Lives: \(lives)"
            if lives <= 0 {
                changeScene(won: false)
            }
        }
    }
    
    func changeScene(won: Bool) {
        let reveal = SKTransition.flipVertical(withDuration: 0.5)
        let gameoverScene = GameOverScene(size: self.size, won: won)
        self.view?.presentScene(gameoverScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "upButton" {
                movePlayer(up: true)
            } else if node.name == "downButton" {
                movePlayer(up: false)
            }
        }
    }

    func movePlayer(up: Bool) {
        let moveDistance: CGFloat = 50.0
        let newY = player.position.y + (up ? moveDistance : -moveDistance)
        let clampedY = min(max(newY, player.size.height / 2), size.height - player.size.height / 2)
        player.position = CGPoint(x: player.position.x, y: clampedY)
    }
}
