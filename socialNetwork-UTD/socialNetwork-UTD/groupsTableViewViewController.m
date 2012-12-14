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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    countries = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [countries count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[countries allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *continent = [self tableView:tableView titleForHeaderInSection:section];
	return [[countries valueForKey:continent] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *country = [[countries valueForKey:continent] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = country;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *country = [[countries valueForKey:continent] objectAtIndex:indexPath.row];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"You selected %@!", country]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)backToMain
{
    messengerViewController *mainVw=[[messengerViewController alloc]initWithNibName:nil bundle:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self presentViewController:mainVw animated:YES completion:NULL];
}


-(BOOL)shouldAutorotate
{
    return NO;
}


@end
