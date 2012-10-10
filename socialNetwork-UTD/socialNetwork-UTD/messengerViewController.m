//
//  messengerViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "messengerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface messengerViewController ()
{
    CLLocationManager *locManager;
    IBOutlet UILabel *currLoc;
    
}

-(NSString *)calcPos;

@end

@implementation messengerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    locManager=[[CLLocationManager alloc]init];
    locManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    locManager.distanceFilter=kCLDistanceFilterNone;
    currLoc.text=[self calcPos];
}

-(NSString *)calcPos
{
    NSString *curPos=[NSString stringWithFormat:@"latitude %f, longitude %f",locManager.location.coordinate.latitude,locManager.location.coordinate.longitude];
    return curPos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
