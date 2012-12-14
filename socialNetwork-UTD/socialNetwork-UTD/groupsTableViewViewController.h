//
//  groupsTableViewViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 04/12/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupsTableViewViewController : UIViewController
{
    IBOutlet UITableView *tabVw;
    NSDictionary *countries;
}

-(IBAction)backToMain;

@end
