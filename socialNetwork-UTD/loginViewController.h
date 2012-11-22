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

@interface loginViewController : UIViewController
{
    IBOutlet UIButton *switchBackBtn;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *passwordField;
    int appearFlagCheck;
}
-(IBAction)swichBackMain;
-(IBAction)returnKeyBoard:(id)sender;


@end
