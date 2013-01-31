//
//  signupUserViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/30/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messengerViewController.h"
//#import "messengerRESTclient.h"

@interface signupUserViewController : UIViewController
{
    IBOutlet UIButton *goBtn;
    IBOutlet UIBarButtonItem *backToLoginBtn;
    IBOutlet UITextField *dispNameField;
    IBOutlet UITextField *newPasswordField;
    IBOutlet UITextField *retypePasswordField;
    IBOutlet UITextField *emailField;
    
    NSString *userID;
    NSString *userName;
    NSString *password;
    NSString *emailID;
    NSString *combinerString;
    int retVal;
    
    //messengerRESTclient *restObj;
    
}

-(IBAction)returnKeyboard:(id)sender;
-(IBAction)switchBackLogin;
-(IBAction)sendNewUserData;


@end
