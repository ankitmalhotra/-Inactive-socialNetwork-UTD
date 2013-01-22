//
//  messengerViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupsTableViewViewController.h"
#import "friendsViewController.h"
#import "newPostViewController.h"

/*static variable declaration*/

/*Flag to ensure initial login view is displayed only once*/
static int appearCheck=0;
/*Mutable Array object to collate group names inbound from server*/
static NSMutableArray *groups;


@interface messengerViewController : UIViewController
{
    IBOutlet UIBarButtonItem *friendsBtn;
    IBOutlet UIBarButtonItem *groupsBtn;
    IBOutlet UIBarButtonItem *postBtn;
    IBOutlet UIBarButtonItem *stopUpdate;
    NSArray *friends;
}

@property (readwrite,assign) NSString *gpNames;

-(IBAction)backgroundTouched:(id)sender;
-(void)getUserId:(NSString *)userId;
-(IBAction)showGroups;
-(IBAction)showFriends;
-(NSMutableArray *)setGroupObjects:(NSMutableArray *)inputArray:(int)toReturn;
-(NSArray *)getFriendObjects;
-(void)setSelectedIndex:(NSString *)indexVal;
-(IBAction)createPost;
-(IBAction)stopUpdate;


@end
