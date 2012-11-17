//
//  messengerViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messengerViewController : UIViewController
{
    IBOutlet UILabel *currLoc;
    IBOutlet UILabel *distMoved;
    IBOutlet UIButton *loginBtn;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *encryptBtn;
    IBOutlet UIButton *decryptBtn;
    IBOutlet UITextView *messageVw;
    IBOutlet UILabel *encryptLabel;
    IBOutlet UILabel *decryptLabel;
    int appearCheck;
}

-(IBAction)returnKeyBoard:(id)sender;
-(void)generateKeyPairs;
-(IBAction)callEncrypt;
-(IBAction)callDecrypt;


@end
