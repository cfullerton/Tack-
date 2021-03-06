//
//  ViewController.h
//  Tack!
//
//  Created by Conner Fullerton on 10/19/15.
//  Copyright © 2015 Conner Fullerton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <coreLocation/Corelocation.h>
#import <iAd/iAd.h>
@import WatchConnectivity;
@interface ViewController : UIViewController<ADBannerViewDelegate, CLLocationManagerDelegate,UITextFieldDelegate,WCSessionDelegate>
- (IBAction)firstWindAction:(id)sender;
@property (nonatomic) WCSession* session;
@property (weak, nonatomic) IBOutlet UIButton *firstWind;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrow;
@property (weak, nonatomic) IBOutlet UIButton *windShot;
- (IBAction)setWind:(id)sender;


@end

