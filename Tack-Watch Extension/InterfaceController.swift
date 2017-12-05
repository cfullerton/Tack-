//
//  InterfaceController.swift
//  Tack-Watch Extension
//
//  Created by Conner Fullerton on 11/27/17.
//  Copyright © 2017 Conner Fullerton. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    var session : WCSession!
    var timer = Timer()
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        sendButtonPress(button: "getData")
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
       sendButtonPress(button: "getData")
       
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
       
        super.willActivate()
        if WCSession.isSupported() {
            let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
            let session = WCSession.default
            session.delegate = watchDelegate
            session.activate()
            
        }
        scheduledTimerWithTimeInterval()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }
    @IBAction func gunPressed() {
        //send gun pressed event
        sendButtonPress(button: "gun")
        sendButtonPress(button: "getData")
    }
    @IBAction func windPressed() {
        //send wind pressed
        sendButtonPress(button: "wind")
    }
    func sendButtonPress(button:String) {
        let applicationDict = ["button":button]
        WCSession.default.sendMessage(applicationDict, replyHandler: {(replyMessage:[String : Any]) -> Void in
            let heading = replyMessage["heading"] as? String
            let angleOff = replyMessage["angleOff"] as? String
            let headOrLift = replyMessage["headOrLift"] as? String
            //Use this to update the UI instantaneously (otherwise, takes a little while)
            DispatchQueue.main.async() {
                self.headingLabel.setText(heading);
                self.offLabel.setText(angleOff);
                self.liftLabel.setText(headOrLift)
                
                
            }
        }, errorHandler: {(error ) -> Void in
            // catch any errors here
        })
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void)
 
    {
        let heading = message["heading"] as? String
        let angleOff = message["angleOff"] as? String
        let headOrLift = message["headOrLift"] as? String
        let speed = message["speed"] as? String
       
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            self.headingLabel.setText(heading);
            self.offLabel.setText(angleOff);
            self.liftLabel.setText(headOrLift)
            self.speedLabel.setText(speed)
            
        }
       
 
    }
    
    @IBOutlet var speedLabel: WKInterfaceLabel!
    
    @IBOutlet var liftLabel: WKInterfaceLabel!
    @IBOutlet var offLabel: WKInterfaceLabel!
    @IBOutlet var headingLabel: WKInterfaceLabel!
}
