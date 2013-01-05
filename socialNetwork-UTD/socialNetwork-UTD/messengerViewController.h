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
#import "friendsViewController.h"
#import "newPostViewController.h"
//#import "CurrencyConvertorSvc.h"

static int appearCheck=0;

@interface messengerViewController : UIViewController
{
    IBOutlet UIBarButtonItem *friendsBtn;
    IBOutlet UIBarButtonItem *groupsBtn;
    IBOutlet UIBarButtonItem *postBtn;
    //IBOutlet UINavigationController *tblView;
    /*Group names*/
    NSArray *groups;
    NSArray *friends;
}

@property (readwrite,assign) NSString *gpNames;

-(IBAction)backgroundTouched:(id)sender;
-(void)getUserId:(NSString *)userId;
-(void)processRequest;
-(void)processResponse:(GroupsDataServiceServiceSoap11BindingResponse *)response;
-(IBAction)showGroups;
-(IBAction)showFriends;
-(NSArray *)getGroupObjects;
-(NSArray *)getFriendObjects;
-(void)setSelectedIndex:(NSString *)indexVal;
-(IBAction)createPost;


@end
