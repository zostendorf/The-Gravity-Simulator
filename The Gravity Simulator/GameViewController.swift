//
//  GameViewController.swift
//  The Gravity Simulator2
//
//  Created by Zachary Ostendorf on 10/15/16.
//  Copyright (c) 2016 Zachary Ostendorf. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            
            skView.presentScene(scene)
            gameScene = scene
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let newSafeArea = UIEdgeInsets()
        // Adjust the safe area to accommodate
        //  the width of the side view.
        
//        if let sideViewWidth = view?.bounds.size.width {
//            newSafeArea.right += sideViewWidth
//        }
//        // Adjust the safe area to accommodate
//        //  the height of the bottom view.
//        if let bottomViewHeight = view?.bounds.size.height {
//            newSafeArea.bottom += bottomViewHeight
//        }
        // Adjust the safe area insets of the
        //  embedded child view controller.
       // let child = self.childViewControllers[0]
       // if #available(iOS 11.0, *) {
        //    child.additionalSafeAreaInsets = //newSafeArea
       // } else {
            // Fallback on earlier versions
       // }
    }
    
    

    //Button to remove all objects from the GameScene
    @IBAction func clearButtonAction(_ sender: UIButton) {
        
        print("Clear Button was clicked")
        gameScene.removeAllChildren()
    }
    
  
    
    
    
    @IBOutlet weak var ClearButton: UIButton!
    override var shouldAutorotate : Bool {
        return true
        
    }
  
    
        
    @IBAction func BallSizer(_ sender: UISlider) {
        
        gameScene.ballSizeVar = Int(sender.value)
        
    }
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
