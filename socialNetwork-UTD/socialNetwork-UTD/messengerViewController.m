//
//  messengerViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "messengerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <MapKit/MapKit.h>


@interface messengerViewController ()
{
    /*Location constants*/
    CLLocationManager *locManager;
    CLLocation *currLocation;
    CLLocation *getLocationList[200];
    CLLocationCoordinate2D *locAnnotation;
    CLLocationCoordinate2D *userCoord;
    IBOutlet UILabel *currLoc;
    //SecKeyRef *kRef;
    
    /*XML Parser constants*/
    NSXMLParser *xmlParser;
	NSMutableData *webData;
	NSMutableString *soapResults;
	BOOL recordResults;
    
    /*Login View constants*/
    UIAlertView *loginView;
    UITextField *loginUsernameField;
    UITextField *loginPassworField;
    UILabel *loginUserNameLabel;
    UILabel *loginPasswordLabel;
    
}

-(CLLocation *)calcPos;

@end

@implementation messengerViewController

- (void)viewDidLoad
{
    /*Get Location*/
    [super viewDidLoad];
    locManager=[[CLLocationManager alloc]init];
    locManager.desiredAccuracy=kCLLocationAccuracyBest;
    locManager.distanceFilter=kCLDistanceFilterNone;
    currLocation = [self calcPos];   /*pass this value to DB holding group locations*/
    NSString *showPos=[NSString stringWithFormat:@"lat: %f,long: %f",currLocation.coordinate.latitude,currLocation.coordinate.longitude ];
    currLoc.text=showPos;
    NSLog(@"Current user position: %@",showPos);
    
    CLLocation *curPos3=[[CLLocation alloc]initWithLatitude:24.100000 longitude:1.000000];
    typedef double CLLocationDistance;
    CLLocationDistance dist = [curPos3 distanceFromLocation:currLocation];
    NSLog(@"distance is: %f KM",(dist)/1000);

    
    /*Login Box*/
    //loginView = [[UIAlertView alloc]initWithFrame:CGRectMake(100.0, 20.0, 200.0, 300.0)];
    loginView =[[UIAlertView alloc]init];
    [loginView setDelegate:self];
    [loginView setTitle:@"Login"];
    [loginView setMessage:@" "];
    [loginView addButtonWithTitle:@"Cancel"];
    [loginView addButtonWithTitle:@"OK"];
    
    /*Adding labels to login view*/
    loginUserNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(20.0,45.0,100.0,25.0)];
    //[loginUserNameLabel setBackgroundColor:[UIColor whiteColor]];
    [loginUserNameLabel setText:@"Username"];
    [loginView addSubview:loginUserNameLabel];
    
    loginPasswordLabel =[[UILabel alloc]initWithFrame:CGRectMake(20.0,75.0,90.0,25.0)];
    [loginPasswordLabel setBackgroundColor:[UIColor whiteColor]];
    [loginPasswordLabel setText:@"Password"];
    [loginView addSubview:loginPasswordLabel];
    
    
    /*Adding texfields to login view*/
    loginUsernameField =[[UITextField alloc]initWithFrame:CGRectMake(140.0, 45.0, 180.0, 25.0)];
    //[loginUsernameField setBackgroundColor:[UIColor whiteColor]];
    [loginView addSubview:loginUsernameField];
    
    loginPassworField =[[UITextField alloc]initWithFrame:CGRectMake(140.0, 75.0, 180.0, 25.0)];
    [loginPassworField setBackgroundColor:[UIColor whiteColor]];
    [loginView addSubview:loginPassworField];
    
    [loginView show];
    
    
    
    /*Start XML request*/
    recordResults=NO;
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *mutableURL = [NSMutableURLRequest requestWithURL:url];
    [mutableURL addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [mutableURL addValue:@"http://www.google.com" forHTTPHeaderField:@"SOAPAction"];
    [mutableURL setHTTPMethod:@"POST"];
    [mutableURL setHTTPBody:[soapResults dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:mutableURL delegate:self];
    if(conn)
    {
        webData=[[NSMutableData data]retain];
        NSLog(@"Connection is acive: ");
    }
    else
    {
        NSLog(@"Connection is null..");
    }
}


/*XML delegate methods*/
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [webData setLength:0];
    NSHTTPURLResponse * httpResponse;
    httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [webData appendData:data];
    NSLog(@"webdata: %@", data);
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	NSLog(@"error with the connection");
	[connection release];
	[webData release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received bytes %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"xml %@",theXML);
	[theXML release];
    
	if(xmlParser)
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData:webData];
	//[xmlParser setDelegate:self];
	[xmlParser setShouldResolveExternalEntities:YES];
	[xmlParser parse];
    
	[connection release];
	[webData release];
}


/*XML Response handlers*/
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"Symbol"] || [elementName isEqualToString:@"Last"] || [elementName isEqualToString:@"Time"] )
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc]init];
		}
		recordResults = YES;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(recordResults)
	{
		[soapResults appendString:string];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"Symbol"] || [elementName isEqualToString:@"Last"] || [elementName isEqualToString:@"Time"] )
	{
		recordResults = NO;
		NSLog(@"%@", soapResults);
		[soapResults release];
		soapResults = nil;
	}
}




/*Function calls*/
-(CLLocation *)calcPos
{
    CLLocation *curPos=[[CLLocation alloc]initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
    double lat=24.000000;
    double longt=1.000000;
    CLLocation *curPos2=[[CLLocation alloc]initWithLatitude:lat longitude:longt];
    return curPos2;

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end