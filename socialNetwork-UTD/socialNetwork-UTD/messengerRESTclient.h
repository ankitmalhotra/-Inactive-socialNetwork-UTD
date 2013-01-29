//
//  messengerRESTclient.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/20/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRESTclient.h"
@interface messengerRESTclient : NSObject
{
    BaseRESTclient *accessPtr;
    NSMutableData *wipData;
}

-(void)receiveMessage:(NSString *)message;
-(int)sendMessage:(NSString *)data;

@end
