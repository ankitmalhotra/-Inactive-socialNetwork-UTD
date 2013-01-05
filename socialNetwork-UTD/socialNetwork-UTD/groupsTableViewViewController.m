//
//  groupsTableViewViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 04/12/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "groupsTableViewViewController.h"
#import "messengerViewController.h"

@interface groupsTableViewViewController ()

@end

@implementation groupsTableViewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    messengerViewController *grabGroupsObj=[[messengerViewController alloc] init];
    groupList=[grabGroupsObj getGroupObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [countries count];
    return [arr count];
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    selectedIndex=[groupList objectAtIndex:[indexPath row]];
    cell.textLabel.text=selectedIndex;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=[groupList objectAtIndex:[indexPath row]];
    messengerViewController *setIndexObj=[[messengerViewController alloc] init];
    [setIndexObj setSelectedIndex:selectedIndex];
    [self dismissViewControllerAnimated:YES completion:NULL];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(IBAction)backToMain
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)createGroup
{
    UIAlertView *createAlert=[[UIAlertView alloc]initWithTitle:@"New Group" message:[NSString stringWithFormat:@"Enter the group name"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [createAlert show];
}


-(BOOL)shouldAutorotate
{
    return NO;
}


@end
