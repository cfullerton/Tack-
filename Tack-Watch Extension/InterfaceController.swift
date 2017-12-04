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
    
 /*   override init() {
        super.init()
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
 */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
       
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
        
    }
    @IBAction func windPressed() {
        //send wind pressed
        sendButtonPress(button: "wind")
    }
    func sendButtonPress(button:String) {
        let applicationDict = ["button":button]
       /*
        do {
            try WCSession.default.updateApplicationContext(applicationDict)
        } catch {
            print("error")
        }
        */
        WCSession.default.sendMessage(applicationDict, replyHandler: {([String : Any]) -> Void in
            // handle reply from iPhone app here
        }, errorHandler: {(error ) -> Void in
            // catch any errors here
        })
    }
     func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void)
 
    /* func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) */
    {
        let heading = message["heading"] as? String
        let angleOff = message["angleOff"] as? String
        let headOrLift = message["headOrLift"] as? String
        self.headingLabel.setText("test");
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            self.headingLabel.setText(heading);
            self.offLabel.setText(angleOff);
            self.liftLabel.setText(headOrLift)
            
            
        }
        self.headingLabel.setText(heading);
        self.offLabel.setText(angleOff);
        self.liftLabel.setText(headOrLift)
    }

    @IBOutlet var liftLabel: WKInterfaceLabel!
    @IBOutlet var offLabel: WKInterfaceLabel!
    @IBOutlet var headingLabel: WKInterfaceLabel!
}
