//
//  signupUserViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/30/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import "signupUserViewController.h"

@interface signupUserViewController ()

@end

@implementation signupUserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(IBAction)switchBackLogin
{
    /*Push back to login view*/
   // loginViewController *loginPtr=[[loginViewController alloc]initWithNibName:nil bundle:nil];
    //[self presentViewController:loginPtr animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*Resign the keyboard on pressing return*/
-(IBAction)returnKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)sendNewUserData
{
    userID=dispNameField.text;
    userName=dispNameField.text;
    password=newPasswordField.text;
    emailID=emailField.text;
    combinerString=[userName stringByAppendingString:password];
    double hashval=(int)combinerString;
    
    //restObj=[[messengerRESTclient alloc]init];
    //retVal=[restObj sendMessage:hashval :userName :password :emailID :@"add"];
    if(retVal==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *signUpSuccessAlert=[[UIAlertView alloc]initWithTitle:@"SignUp successful" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [signUpSuccessAlert show];
        [signUpSuccessAlert release];
    }
    else
    {
        UIAlertView *signUpFailAlert=[[UIAlertView alloc]initWithTitle:@"SignUp Failed" message:@"Connection failiure" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [signUpFailAlert show];
        [signUpFailAlert release];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
