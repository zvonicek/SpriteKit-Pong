//
//  Ball.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 24.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit
import Foundation

enum MissedState {
    case None, Left, Right
}

class BallSprite: SKSpriteNode {
    var lastMissed = MissedState.None
    
    init() {
        let size = CGSizeMake(10, 10)
        super.init(texture: nil, color: UIColor.whiteColor(), size: size);
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        
        self.userInteractionEnabled = false
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func initializePosition() {
        self.position = CGPointMake(CGRectGetWidth(parent!.frame) / 2.0, CGFloat.random(min: 0, max: CGRectGetHeight(parent!.frame)))
    }
    
    func isMissed() -> MissedState {
        if position.x < 0 {
            lastMissed = .Left
            return .Left
        } else if (position.x > CGRectGetMaxX(parent!.frame)) {
            lastMissed = .Right
            return .Right
        } else {
            return .None
        }
    }
    
    func serve() {
        if lastMissed == .Left {
            self.physicsBody!.applyImpulse(CGVectorMake(1, 1))
        } else {
            self.physicsBody!.applyImpulse(CGVectorMake(-1, -1))
        }
    }
}