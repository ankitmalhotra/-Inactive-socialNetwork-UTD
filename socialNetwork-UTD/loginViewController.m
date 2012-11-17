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
}

-(IBAction)swichBackMain
{
    username = nameField.text;
    userPwd = passwordField.text;
    /*Generate Key Pairs, call encryption routine*/
    messengerViewController *messengerHandler = nil;
    [messengerHandler generateKeyPairs];
    messengerViewController *mainVw=[[messengerViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:mainVw animated:YES completion:NULL];
    NSLog(@"val: %d");
    
    
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
