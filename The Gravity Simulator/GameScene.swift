//
//  GameScene.swift
//  The Gravity Simulator2
//
//  Created by Zachary Ostendorf on 10/15/16.
//  Copyright (c) 2016-2021 Zachary Ostendorf. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ballSizeVar: Int = 0
    
    //No idea how this works, for the balls collision
    let ballCategory:UInt32 = 0x1 << 1
    
    //global array for balls
    var ballAry = [SKShapeNode]();
    //counter for balls array
    var ballCounter = Int();
    
    //global array for tempBalls. Should only be storing 1 item
    var tempBallAry = [SKShapeNode]();
    //count for temp balls array
    var tempBallCounter = Int();
    
    //global array for tempBalls. Should only be storing 1 item
    var lineAry = [SKShapeNode]();
    //count for temp balls array
    var tempLineCounter = Int();
    
    /*Time variables*/
    //captures the time, later set to the time of the touch
    var timePass: TimeInterval = CACurrentMediaTime();
    //captures the time, later set to the length of time screen was touched
    var DeltaTimePass: TimeInterval = CACurrentMediaTime();
    
    /*Global Touch Variable*/
    //global boolean for isTouched, set to true in TouchBegans(), set to false is touch ends
    var globalIsTouched: Bool = false
    //global boolean for touchMove, set to be true in TouchMoved(), set to be false in TouchBegans
    var globalTouchMoved: Bool = false
    //global location of touch
    var globalBallLocation = CGPoint(x: 0, y: 0)
    
    /*Ball Trajectory Varibles*/
    var globalStartPoint = CGPoint(x: 0,y: 0)
    var globalEndPoint = CGPoint(x: 0,y: 0)
    
    //substitute Clar button, currently an SKNode
    var button: SKNode! = nil
    
    enum ColliderType:UInt32{
        case ball = 1
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        self.physicsWorld.contactDelegate = self
        
        //WTF, tried to remove this code and the game crashes during touch release of first ball
        // Create a simple red rectangle that's 100x44
       button = SKSpriteNode(color: SKColor.white, size: CGSize(width: self.frame.width / 10, height: self.frame.height / 14))
        // Put it in the center of the scene
        button.position = CGPoint(x:self.frame.maxX, y:self.frame.minY);
        //Add button to scene
       self.addChild(button)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        //If touch is active and hasnt moved from its original location
        if globalTouchMoved==false && globalIsTouched==true {
            //If tempBallAry is NOT empty, delete the last item in the array
            if !tempBallAry.isEmpty{
                tempBallAry.last?.removeFromParent()
            }
            
            //set DeltaTimePass and then create tempball
                DeltaTimePass = CACurrentMediaTime() - timePass
                //tempBallCreate(globalBallLocation)
        }
        
        //Draws aim line
        drawLine()
    }
    
    /* Called when a touch begins */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //capture the current time of the start of the touch
        timePass = CACurrentMediaTime();
        //set isTouched to true
        globalTouchMoved = false
        globalIsTouched = true
        
        for touch in touches {
            let touchStartLocation = touch.location(in: self)
            //set global location of touch
            globalBallLocation = touchStartLocation
            globalStartPoint = touchStartLocation
            globalEndPoint = touchStartLocation
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            globalEndPoint = touch.location(in: self)
        }
        
        globalTouchMoved = true
        
        //If tempBallAry is NOT empty, delete the last item in the array
        if !tempBallAry.isEmpty{
            tempBallAry.last?.removeFromParent()
        }
        
        //set DeltaTimePass and then create tempball
        DeltaTimePass = CACurrentMediaTime() - timePass
        //tempBallCreate(globalBallLocation)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        if !lineAry.isEmpty {
            lineAry.last?.removeFromParent()
        }
        
        //If tempBallAry is NOT empty, delete the last item in the array
        if !tempBallAry.isEmpty{
            tempBallAry.last?.removeFromParent()
        }
        
        //Set GlobalIsTouched to false
        globalIsTouched = false
        
        //Get Touch End Location
        let touchEndLocation = touch.location(in: self)
     
        //Set End Point for impluse vector
        globalEndPoint.x = touchEndLocation.x
        globalEndPoint.y = touchEndLocation.y
      
        //Captures the length of time touched for sizing the ball proportionally
        DeltaTimePass = CACurrentMediaTime() - timePass
        
        //IF the touch is in the location of the clear button, remove all children then re-add the button
        if button.contains(touchEndLocation) {
            self.removeAllChildren()
            self.addChild(button)
        }
            
        //ELSE create the ball at the Global Ball Location, and Apply the Impluse
        else{
            ballCreate(globalBallLocation)
            
            /*Force variables & Application of force*/
            let vector = CGVector(dx: (globalStartPoint.x - globalEndPoint.x) * 3 * pow(CGFloat(ballSizeVar + 1),2), dy: (globalStartPoint.y - globalEndPoint.y) * 3 * pow(CGFloat(ballSizeVar + 1),2))
            // apply force to ball
            ballAry[ballCounter-1].physicsBody?.applyImpulse(vector)
        }
    }
    
    /*Collision & Deletion function. Parameters: (ball, ball)*/
    func didBegin(_ contact: SKPhysicsContact){
   
        if contact.bodyA.mass < contact.bodyB.mass {
            
            //let tempMass = contact.bodyA.mass
            contact.bodyA.node?.removeFromParent()
         //   contact.bodyB.node?.setScale(1 + (0.1 * tempMass))
         //   contact.bodyB.mass = contact.bodyB.mass + contact.bodyA.mass
        } else  {
            
             // let tempMass = contact.bodyB.mass
            contact.bodyB.node?.removeFromParent()
             //contact.bodyA.node?.setScale(1 + (0.1 * tempMass))
            // contact.bodyA.mass = contact.bodyA.mass + contact.bodyB.mass
        }
    }
//    
//    /*tempBall Size, Mass, Density, Gravity Initialization*/
//    func tempBallCreate(_ location: CGPoint){
//        
//        //tempBall declaration
//        let tempBall = SKShapeNode(circleOfRadius: CGFloat(2 + ballSizeVar))
//        
//        //tempBall Characteristics
//        tempBall.fillColor = getBallColor(CGFloat(ballSizeVar * 10))
//        tempBall.strokeColor = getBallColor(CGFloat(ballSizeVar * 10))
//        tempBall.position = location
//        
//        //ball body creation with size proportional ballSizeVar received from UISlider
//        tempBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(2 + ballSizeVar))
//        tempBall.physicsBody?.mass = CGFloat(2 + ballSizeVar)

//                    /*tempBall body's mass proportional to the length of the touch
//                    tempBall.physicsBody?.mass = CGFloat(DeltaTimePass)
//                    tempBall.physicsBody?.density = CGFloat(DeltaTimePass)
//                    */
//        
//        //tempBall physical characteristics
//        tempBall.physicsBody?.affectedByGravity = false
//        tempBall.physicsBody?.allowsRotation = false
//        //ball.physicsBody?.restitution = 0.1
//        tempBall.physicsBody?.friction = 20
//        tempBall.physicsBody?.linearDamping = 0
//        tempBall.physicsBody?.angularDamping = 1
//        tempBall.physicsBody?.angularVelocity = 0.2
//
//        //something about setting up the bit mask for collision
//        tempBall.physicsBody?.usesPreciseCollisionDetection = true
//        tempBall.physicsBody!.categoryBitMask = ColliderType.ball.rawValue
//        tempBall.physicsBody!.contactTestBitMask = ColliderType.ball.rawValue
//        tempBall.physicsBody!.collisionBitMask =  ColliderType.ball.rawValue
//        tempBall.physicsBody!.isDynamic = false
//        tempBallAry.append(tempBall)
//        self.addChild(tempBallAry.last!)
//    }
    
    /*Ball Size, Mass, Density, Gravity Initialization*/
    func ballCreate(_ location: CGPoint){
        
        /*Instance of Ball*/
        //ball declaration with size proportional to 2 + ballSizeVar received from UISlider
        let ball = SKShapeNode(circleOfRadius: CGFloat((Float(2 + ballSizeVar))))
        
        /*Ball Characteristics*/
        ball.fillColor = getBallColor(CGFloat(ballSizeVar * 10))
        ball.position = location
        
        /*Physical Characteristics*/
        //ball body creation with size proportional to ballSizeVar received from UISlider
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(logf(Float(2 + ballSizeVar))))
        ball.physicsBody?.mass = pow(CGFloat(2 + ballSizeVar),3)
        ball.physicsBody?.affectedByGravity = false
                //other ball characteristics
                //        angularVelocity
                //        allowsRotation
                //        restitution
                //        friction
                //        linearDamping
                //        angularDamping
        
        /*Ball Masking Characteristics, used for collision*/
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody!.categoryBitMask = ColliderType.ball.rawValue
        ball.physicsBody!.contactTestBitMask = ColliderType.ball.rawValue
        ball.physicsBody!.collisionBitMask =  ColliderType.ball.rawValue
        ball.physicsBody!.isDynamic = true
        
        /*Add Gravity to Ball*/
        //calls function to create gravity, ball is passed so gravity can be added as child
        createGravityField(ball)
        
        /*Adds the Ball to Scene*/
        //add ball to array
        ballAry.append(ball)
        //add array index as child of scene
        self.addChild(ballAry[ballCounter])
        //increment ball counter
        ballCounter += 1;
    }
    
    func createGravityField(_ ball: SKShapeNode){
        
        /*Instance of radial gravity field to surround the ball*/
        //gravity field creation
        let gravityField = SKFieldNode.radialGravityField()
        //gravityField.minimumRadius = pow(Float(ballSizeVar),2)
        gravityField.isEnabled = true
        gravityField.strength = 0.0002 * pow(Float(2 + ballSizeVar),2) * 2.71828182845904523536
        gravityField.falloff = 0.01
        gravityField.region = SKRegion (size: self.size)
        
        //ball is passed so gravity can be added as child
        ball.addChild(gravityField)
    }
    
    
    func getBallColor(_ ballSize: CGFloat) -> SKColor{
        let hue = 0.167 * (1 - ballSize/100.0)
        return SKColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    /*Clear Button Function*/
    func removeBalls(){
        self.removeAllChildren()
    }
    
    /*Draws the Trejectory Line*/
    func drawLine(){

        if globalIsTouched {
            if !lineAry.isEmpty {
        lineAry.last?.removeFromParent()
            }
        let bezierPath = UIBezierPath()
        let startPoint = globalStartPoint
        let endPoint = globalEndPoint
        bezierPath.move(to: startPoint)
        bezierPath.addLine(to: endPoint)
        bezierPath.close()
        let pattern : [CGFloat] = [10.0, 10.0]
        let dashed = CGPath (__byDashing: bezierPath.cgPath, transform: nil, phase: 0, lengths: pattern, count: 2)
        bezierPath.stroke()
        let shapeNode = SKShapeNode(path: dashed!)
        shapeNode.strokeColor = UIColor.cyan
        lineAry.append(shapeNode)
        self.addChild(lineAry.last!)
        }
    }
}
