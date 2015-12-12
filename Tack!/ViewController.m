//
//  ViewController.m
//  Tack!
//
//  Created by Conner Fullerton on 10/19/15.
//  Copyright © 2015 Conner Fullerton. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *liftHead;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIButton *gun;
@property (weak, nonatomic) IBOutlet UITextField *inputTA;
- (IBAction)taSubmit:(id)sender;

@property (retain, nonatomic) CLLocationManager *LocationManager;
@property (retain, nonatomic) CLHeading *currentHeading;
@end
@interface ViewController ()
{
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
    CLLocationSpeed speed;
}
@end

@implementation ViewController
int windDirection;
int tackingAngle = 45;
int minutes=5;
int seconds=0;
bool timeMode=0;
NSTimer *timer;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentHeading = [[CLHeading alloc] init];
    self.LocationManager = [[CLLocationManager alloc] init];
    self.LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.LocationManager.headingFilter =1;
    self.LocationManager.delegate = self;
    self.inputTA.delegate=self;
    [self.LocationManager startUpdatingHeading];
    [self.LocationManager requestWhenInUseAuthorization];
    [self.LocationManager startMonitoringSignificantLocationChanges];
    [self.LocationManager startUpdatingLocation];
    self.firstWind.enabled = NO;
    self.windShot.enabled = NO;
}
- (void)timerStart {
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
-(void)timerFired{
    if (minutes>0){
        if (seconds==0){
            minutes -=1;
            seconds=59;
        }else if (seconds>0){
            seconds-=1;
        }
        if (timeMode) {
            self.headingLabel.text = [NSString stringWithFormat:@"%d:%d",minutes,seconds] ;

        }
    }else {
        if (seconds==0){
            [timer invalidate];
            minutes =5;
            seconds=0;
            timeMode=false;
            [self.gun setTitle:@"Gun!" forState:UIControlStateNormal];
        }else if (seconds>0){
            seconds-=1;
            self.headingLabel.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds] ;
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    _adBanner.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }}
#pragma Location Manager Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *loc =locations.lastObject;
    speed= loc.speed *1.94384;
    if (speed >=0){
        self.speedLabel.text = [NSString stringWithFormat:@"%.02f", speed];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.currentHeading = newHeading;
    if (!timeMode){
        self.headingLabel.text = [NSString stringWithFormat:@"%d", (int)newHeading.magneticHeading];
    }
    if (windDirection)
    {
        int angleOff = abs(((int)newHeading.magneticHeading - windDirection + 360) %360); //amount lifted or headed
        if (angleOff > 180)
        {
            angleOff = 360 - angleOff;
        }
        int liftAmount= abs(tackingAngle-angleOff);
        
        if (angleOff>tackingAngle)
        {
            self.amountLabel.text = [NSString stringWithFormat:@"%d", (int)liftAmount];
            self.liftHead.text= @"-";
            self.liftHead.textColor = [UIColor redColor];
        }else{
            self.amountLabel.text = [NSString stringWithFormat:@"%d", (int)liftAmount];
            self.liftHead.text= @"+";
            self.liftHead.textColor= [UIColor greenColor];
        }
    }
    self.firstWind.enabled = YES;
    self.windShot.enabled = YES;
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
  if (self.currentHeading == nil)
  {
      return YES;
  }
    else
    {
        return NO;
    }
}
- (IBAction)setWind:(id)sender {
    if (self.currentHeading){
        windDirection= (int)self.currentHeading.magneticHeading;
        [self.firstWind removeFromSuperview];
    }
}
- (IBAction)taSubmit:(id)sender {
    
    tackingAngle = self.inputTA.text.intValue / 2;
    if (tackingAngle >90 ||tackingAngle<25) {
        UIAlertView *angleAlert = [[UIAlertView alloc] initWithTitle:@"Tacking Angle" message:@"Tacking Angle should be between 50 and 180 (on a typical boat it is close to 90)" delegate:self cancelButtonTitle:@"got it" otherButtonTitles:nil, nil , nil];
        [angleAlert show];
        tackingAngle=45;
        self.inputTA.text =@"90";
    }
}

- (IBAction)gun:(id)sender {
    if (!timeMode){
        timeMode=true;
        [self timerStart];
        [self.gun setTitle:@"Sync" forState:UIControlStateNormal];
    }else{
        seconds=0;
    }
}
- (IBAction)firstWindAction:(id)sender {
    if (self.currentHeading){
        windDirection= (int)self.currentHeading.magneticHeading;
        [self.firstWind removeFromSuperview];
    }
    
}
@end
