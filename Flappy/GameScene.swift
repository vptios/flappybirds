//
//  GameScene.swift
//  Flappy
//
//  Created by Ameya Vichare on 07/06/17.
//  Copyright © 2017 vit. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    var gameOver = false
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 100
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        
        self.addChild(scoreLabel)
        
        //bird
        
        let birdTexture = SKTexture(image: #imageLiteral(resourceName: "flappy1"))
        
        let birdTexture2 = SKTexture(image: #imageLiteral(resourceName: "flappy2"))
        
        let animation = SKAction.animate(with: [birdTexture,birdTexture2], timePerFrame: 0.1)
        
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        
        bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        
        bird.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        bird.run(makeBirdFlap)
        
        self.addChild(bird)
        
        //ground
        
        var ground = SKNode()
        
        ground.position = CGPoint(x: 0, y: -self.frame.size.height/2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(makePipe), userInfo: nil, repeats: true)

    }
    
    func makePipe() {
        
        if gameOver == false {
            
            //pipe 1
            
            let gapHeight = bird.size.height * 4
            
            let movement = randRange(lower: -self.frame.size.height/4, upper: self.frame.size.height/4)
            
            let pipeTexture = SKTexture(image: #imageLiteral(resourceName: "pipe1"))
            
            pipe1 = SKSpriteNode(texture: pipeTexture)
            
            pipe1.position = CGPoint(x: self.frame.midX + self.frame.size.width/2, y: self.frame.midY + pipe1.size.height/2 + gapHeight/2 + movement)
            
            let movePipe = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width/100))
            
            let removePipe = SKAction.removeFromParent()
            
            let makeAndRemove = SKAction.sequence([movePipe,removePipe])
            
            pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
            
            pipe1.physicsBody?.isDynamic = false
            
            pipe1.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
            
            pipe1.run(makeAndRemove)
            
            self.addChild(pipe1)
            
            //pipe 2
            
            let pipeTexture2 = SKTexture(image: #imageLiteral(resourceName: "pipe2"))
            
            pipe2 = SKSpriteNode(texture: pipeTexture2)
            
            pipe2.position = CGPoint(x: self.frame.midX + self.frame.size.width/2, y: self.frame.midY - pipe2.size.height/2 - gapHeight/2 + movement)
            
            pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
            
            pipe2.physicsBody?.isDynamic = false
            
            pipe2.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
            
            pipe2.run(makeAndRemove)
            
            self.addChild(pipe2)
            
            
            var gap = SKNode()
            
            gap.position = CGPoint(x: self.frame.midX + self.frame.size.width / 2, y: self.frame.midY + movement)
            
            gap.run(makeAndRemove)
            
            gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: gapHeight))
            
            gap.physicsBody?.isDynamic = false
            
            gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
            gap.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
            
            
            self.addChild(gap)

            
        }
        
        
    }

    func randRange (lower: CGFloat , upper: CGFloat) -> CGFloat {
        return CGFloat(lower) + CGFloat(arc4random_uniform(UInt32(upper - lower + 1.0)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score += 1
            
            scoreLabel.text = String(score)
            
        }
        else {
            
            self.speed = 0
            
            gameOver = true
            
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
