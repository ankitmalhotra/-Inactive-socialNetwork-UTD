//
//  messengerRESTclient.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 1/20/13.
//  Copyright (c) 2013 Ankit Malhotra. All rights reserved.
//

#import "messengerRESTclient.h"

@implementation messengerRESTclient

-(void)sendMessage:(NSString *)message
{
    NSLog(@"in..");
    NSString *settingsBundle=[[NSBundle mainBundle]pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        NSLog(@"settings found");
    }
    else
    {
        NSLog(@"settings missing..");
    }
    
    NSDictionary *settings=[NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *prefrences=[settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister=[[NSMutableDictionary alloc]initWithCapacity:[prefrences count]];
    
    for(NSDictionary *prefSpecs in prefrences)
    {
        NSString *key=[prefSpecs objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecs objectForKey:@"DefaultValue"] forKey:key];
        }
        else
        {
            NSLog(@"key not found..");
        }
    }
    [[NSUserDefaults standardUserDefaults]registerDefaults:defaultsToRegister];
    [defaultsToRegister release];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *urlString=[defaults stringForKey:@"server_url"];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/v2/%@",urlString,message]];
    NSLog(@"Sending Request to URL %@", url);

    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
										 cachePolicy:NSURLRequestReloadIgnoringCacheData
									 timeoutInterval:30.0];
    
    
    /*start the async request*/
	[NSURLConnection connectionWithRequest:request delegate:self];
}
/*Received at the start of the response from the server.  This may get called multiple times in certain redirect scenerios.*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	NSLog(@"Received Response");
	NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *) response;;
    
    NSLog(@"response is: %@",response);
    
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
		int status = [httpResponse statusCode];
		
		if (!((status >= 200) && (status < 300)))
        {
			NSLog(@"Connection failed with status %d", status);
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else
        {
			/*make the working space for the REST data buffer.This could also be a file if you want to reduce the RAM footprint*/
			[wipData release];
			wipData = [[NSMutableData alloc] initWithCapacity:1024];
        }
    }
    else
    {
        NSLog(@"response type: %@",httpResponse);
    }
}


/*Can be called multiple times with chunks of the transfer*/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[wipData appendData:data];
}

/*Called once at the end of the request*/
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
	// do a little debug dump
    accessPtr = [[BaseRESTclient alloc]init];
	NSString *xml = [[NSString alloc] initWithData:wipData encoding:NSUTF8StringEncoding];
	NSLog(@"xml = %@", xml);
	[xml release];
	
    NSLog(@"wip data is: %@",wipData);
	[accessPtr parseDocument:wipData];
    
	/*turn off the network indicator*/
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

        
/*On the start of every element, clearn the intraelement text*/
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[accessPtr clearContentsOfElement];
}

/*Called for each element*/
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [accessPtr clearContentsOfElement];
}

@end
