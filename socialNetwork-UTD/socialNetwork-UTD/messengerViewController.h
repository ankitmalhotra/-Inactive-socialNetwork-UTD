//
//  messengerViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupsDataServiceServiceSvc.h"
#import "groupsTableViewViewController.h"
//#import "CurrencyConvertorSvc.h"


static int appearCheck=0;

@interface messengerViewController : UIViewController
{
    IBOutlet UIButton *postButton;
    IBOutlet UITextView *messageVw;
    IBOutlet UIBarButtonItem *friendsBtn;
    IBOutlet UIBarButtonItem *groupsBtn;
    //IBOutlet UINavigationController *tblView;
}

-(IBAction)backgroundTouched:(id)sender;
-(void)getUserId:(NSString *)userId;
-(void)processRequest;
-(void)processResponse:(GroupsDataServiceServiceSoap11BindingResponse *)response;
-(IBAction)postMessage;
-(IBAction)showGroups;
-(IBAction)showFriends;


@end
