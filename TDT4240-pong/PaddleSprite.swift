//
//  PaddleSprite.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 24.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

enum PaddleSide {
    case Left, Right
}

let paddleSidePadding = CGFloat(50.0)
let paddleHeight: CGFloat = 50
let paddleWidth: CGFloat = 10
let maxBounceAngle: CGFloat = CGFloat(65).degreesToRadians()


class PaddleSprite: SKSpriteNode {
    let side: PaddleSide
    
    init(side: PaddleSide) {
        self.side = side
        
        let size = CGSizeMake(paddleWidth, paddleHeight)
        super.init(texture: nil, color: UIColor.whiteColor(), size: size);
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        borderBody.dynamic = false
        borderBody.usesPreciseCollisionDetection = true
        borderBody.categoryBitMask = PhysicsCategory.Paddle
        borderBody.contactTestBitMask = PhysicsCategory.Ball
        // we will handle collision by ourselves
        borderBody.collisionBitMask = PhysicsCategory.None
        
        self.physicsBody = borderBody
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func configSide() {
        if let frame = self.parent?.frame {
            
            switch side {
            case .Left:
                self.position = CGPointMake(CGRectGetMinX(frame) + paddleSidePadding, CGRectGetMidY(frame))
            case .Right:
                self.position = CGPointMake(CGRectGetMaxX(frame) - paddleSidePadding, CGRectGetMidY(frame))
            }
        }
    }
    
    func moveToLocation(location: CGPoint, fromLocation: CGPoint) {
        var paddleY = self.position.y + (location.y - fromLocation.y)
        
        // limit y so that paddle won't leave screen
        paddleY = max(paddleY, self.size.height/2)
        paddleY = min(paddleY, parent!.frame.size.height - self.size.height/2)
        
        self.position = CGPointMake(self.position.x, paddleY)
    }
    
    func getReflectionForBall(ball: BallSprite, atContactPoint point: CGPoint) -> CGVector {
        // range: -paddleHeight/2 .. paddleHeight/2
        let relativeIntersect = self.convertPoint(point, fromNode: ball.parent!)
        
        // range: -1 .. 1
        let normalizedRelativeIntersect = relativeIntersect.y/(paddleHeight/2)
        
        var bounceAngle = -normalizedRelativeIntersect * maxBounceAngle

        if self.side == .Right {
            bounceAngle = π - bounceAngle
        }
        
        let ballVx = 400 * cos(bounceAngle)
        let ballVy = 400 * -sin(bounceAngle)
        
        return CGVectorMake(ballVx, ballVy)
    }
}