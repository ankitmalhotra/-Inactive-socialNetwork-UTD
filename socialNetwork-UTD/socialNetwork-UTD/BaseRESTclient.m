//
//  BaseRESTclient.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/20/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import "BaseRESTclient.h"

@implementation BaseRESTclient

    - (id) init
    {
        self = [super init];
        return self;
    }

   /*Clear the contents of the collected inter-element text*/
    - (void) clearContentsOfElement
    {
        [_contentsOfElement release];
    }

    /*Start the parsing process*/
    - (void) parseDocument:(NSData *) data
    {
        mainViewPtr=[[messengerViewController alloc]init];
        NSLog(@"data in: %@",data);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        
        [parser setDelegate:self];
        /*Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser*/
        [parser setShouldProcessNamespaces:YES];
        [parser setShouldReportNamespacePrefixes:YES];
        [parser setShouldResolveExternalEntities:NO];
        
        [parser parse];
        
        [parser release];
    }

    /*Handle the receipt of intraelement text*/
    - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
    {
        NSLog(@"string in: %@",string);
        _contentsOfElement=[NSMutableArray arrayWithObjects:string, nil];
        NSLog(@"contents buid: %@",_contentsOfElement);
        [self callMain:_contentsOfElement];
    }

    -(void)callMain:(NSMutableArray *)mainContents
  {
      [mainViewPtr setGroupObjects:mainContents:1];
  }
    /*Trim leading and trailing spaces*/
    - (NSString *)trim:(NSString *)inStr
    {
        return [inStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    - (void) dealloc
    {
        [_contentsOfElement release];
        [super dealloc];
    }

@end
