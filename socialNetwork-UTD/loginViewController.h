//
//  loginViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 13/11/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messengerViewController.h"
#import "secureMessageRSA.h"

static int appearFlagCheck=0;

@interface loginViewController : UIViewController
{
    IBOutlet UIButton *switchBackBtn;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIActivityIndicatorView *spinningView;
}
-(IBAction)swichBackMain;
-(IBAction)returnKeyBoard:(id)sender;
-(IBAction)backgroundTouched:(id)sender;


@end
