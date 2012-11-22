//
//  loginViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 13/11/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "loginViewController.h"
#import "messengerViewController.h"

@interface loginViewController ()
{
    /*User credentials*/
    NSString *username;
    NSString *userPwd;
}
@end
    
@implementation loginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appearFlagCheck+=1;
    NSLog(@"loaded");
    NSLog(@"flagval: %d",appearFlagCheck);
    if(appearFlagCheck>1)
    {
        messengerViewController *mainVw=[[messengerViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:mainVw animated:YES completion:NULL];
    }
}

-(IBAction)swichBackMain
{
    messengerViewController *msgViewCntrl = nil;
    //msgViewCntrl.appearCheck=1;
    NSLog(@"finally set: %d",msgViewCntrl.appearCheck);
    username = nameField.text;
    userPwd = passwordField.text;
    /*Generate Key Pairs routine*/
    [secureMessageRSA generateKeyPairs];
    messengerViewController *mainVw=[[messengerViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:mainVw animated:YES completion:NULL];
    //[messengerViewController setFlag:1];
}

/*resign the keyboard on pressing return*/
-(IBAction)returnKeyBoard:(id)sender
{
    [sender resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
