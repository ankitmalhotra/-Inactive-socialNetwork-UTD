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
    spinningView.hidden=TRUE;
    appearFlagCheck=1;
    NSLog(@"loaded");
    NSLog(@"flagval: %d",appearFlagCheck);    
}

-(IBAction)swichBackMain
{
    /*Accept username and password entered by user*/
    username = nameField.text;
    userPwd = passwordField.text;
    
    /*Signal username to main view*/
    messengerViewController *obj=[[messengerViewController alloc]init];
    [obj getUserId:username];
    
    /*Start SOAP request processing*/
    spinningView.hidden=FALSE;
    [spinningView startAnimating];
    [obj processRequest];
    
    /*Generate Key Pairs routine*/
    [secureMessageRSA generateKeyPairs];
    
    /*Push back main view*/
    messengerViewController *mainVw=[[messengerViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:mainVw animated:YES completion:NULL];
    [spinningView stopAnimating];
}

/*Resign the keyboard on pressing return*/
-(IBAction)returnKeyBoard:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)backgroundTouched:(id)sender
{
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
