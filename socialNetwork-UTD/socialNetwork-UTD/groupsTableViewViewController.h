//
//  groupsTableViewViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 04/12/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupsTableViewViewController : UIViewController
         <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tabVw;
    NSArray *groupList;
    NSString *selectedIndex;
    NSString *grpName;
    UITextField *groupNameField;
}

-(IBAction)backToMain;
-(IBAction)createGroup;

@end
