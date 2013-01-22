//
//  BaseRESTclient.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/20/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "messengerViewController.h"

@interface BaseRESTclient : NSObject
{
    NSMutableArray	*_contentsOfElement;	// Contents of the current element
    messengerViewController *mainViewPtr;
}

- (id) init;
- (void) parseDocument:(NSData *) data ;
- (void) clearContentsOfElement ;
- (void)callMain:(NSArray *)mainContents;

@end
