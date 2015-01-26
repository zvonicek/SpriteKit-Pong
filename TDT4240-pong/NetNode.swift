//
//  NetNode.swift
//  TDT4240-pong
//
//  Created by Petr Zvoníček on 24.01.15.
//  Copyright (c) 2015 Petr Zvoníček. All rights reserved.
//

import SpriteKit

class NetNode: SKShapeNode {
    init(length: CGFloat) {
        let bezierPath = UIBezierPath()
        let startPoint = CGPointMake(0,0)
        let endPoint = CGPointMake(0,length)
        bezierPath.moveToPoint(startPoint)
        bezierPath.addLineToPoint(endPoint)
        
        var pattern : [CGFloat] = [10.0,10.0];
        let dashed = CGPathCreateCopyByDashingPath (bezierPath.CGPath, nil,0,pattern,2);
        
        super.init()
        self.path = dashed
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
