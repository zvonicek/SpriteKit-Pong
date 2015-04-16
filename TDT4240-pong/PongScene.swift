//
//  GameScene.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 22.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Paddle    : UInt32 = 0b1
    static let Ball      : UInt32 = 0b10
    static let Wall      : UInt32 = 0b100
}

enum PlayerSide {
    case Left, Right
}

enum GameState {
    case Stopped, Started, GameOver
}

let maxScore = 21

class PongScene: SKScene, SKPhysicsContactDelegate {
    var ball = BallSprite()
    var leftPaddle = PaddleSprite(side: PlayerSide.Left)
    var rightPaddle = PaddleSprite(side: PlayerSide.Right)
    var leftScore = ScoreNode(side: .Left)
    var rightScore = ScoreNode(side: .Right)
    var gameOverLabel = SKLabelNode(fontNamed: "FFFForward")
    
    var state = GameState.Stopped
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // net node
        let netNode = NetNode(length: size.height)
        netNode.position = CGPointMake(size.width / 2.0, 0)
        self.addChild(netNode)
        
        self.addChild(ball)
        ball.initializePosition()
        
        self.addChild(leftPaddle)
        self.addChild(rightPaddle)
        
        leftScore.position = CGPointMake(CGRectGetMidX(self.frame) - 50, CGRectGetMaxY(self.frame) - 80)
        self.addChild(leftScore)
        rightScore.position = CGPointMake(CGRectGetMidX(self.frame) + 50, CGRectGetMaxY(self.frame) - 80)
        self.addChild(rightScore)
        
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 8, CGRectGetMidY(self.frame) - 20)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    //MARK
    
    override func didMoveToView(view: SKView) {
        leftPaddle.configSide()
        rightPaddle.configSide()
        
        self.addChild(WallNode(physicsBody: SKPhysicsBody(edgeFromPoint: CGPointMake(0, 0), toPoint: CGPointMake(self.size.width, 0))))
        self.addChild(WallNode(physicsBody: SKPhysicsBody(edgeFromPoint: CGPointMake(0, self.size.height), toPoint: CGPointMake(self.size.width, self.size.height))))
    }
    
    func start() {
        state = .Started
        ball.serve()
    }
    
    func stop() {
        state = .Stopped
        ball.physicsBody!.velocity = CGVectorMake(0, 0)
    }
    
    func gameOver() {
        state = .GameOver
        self.addChild(gameOverLabel)
    }
    
    func reset() {
        gameOverLabel.removeFromParent()
        leftScore.reset()
        rightScore.reset()
        ball.lastMissed = .None
        stop()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if state == .Stopped {
            start()
        } else if state == .GameOver {
            reset()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            let paddle = (location.x < CGRectGetMidX(self.frame)) ? leftPaddle : rightPaddle
            paddle.moveToLocation(location, fromLocation: previousLocation)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        // handle missed balls
        let missedState = ball.isMissed()
        if missedState != .None {
            stop()
            ball.initializePosition()
            
            let targetScore = missedState == .Left ? rightScore : leftScore
            targetScore.increment()
            if targetScore.value == maxScore {
                gameOver()
            }
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Paddle != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ball != 0)) {
                if let paddle = firstBody.node as? PaddleSprite {
                    let vector = paddle.getReflectionForBall(ball, atContactPoint: contact.contactPoint)
                    ball.physicsBody!.velocity = vector
                }
        }
    }
}
