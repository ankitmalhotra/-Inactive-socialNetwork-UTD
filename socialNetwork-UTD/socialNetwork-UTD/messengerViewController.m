//
//  messengerViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "messengerViewController.h"
#import "messengerAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "secureMessageRSA.h"
//#import <Security/Security.h>
//#import <CommonCrypto/CommonCrypto.h>
//#import <CommonCrypto/CommonDigest.h>
//#import <MapKit/MapKit.h>


@interface messengerViewController ()
{
    /*Location constants*/
    CLLocationManager *locManager;
    CLLocation *currLocation;
    //SecKeyRef *kRef;
    
    /*XML Parser constants*/
    NSXMLParser *xmlParser;
	NSMutableData *webData;
	NSMutableString *soapResults;
	BOOL recordResults;
    
    
    /*Login View constants*/
    /*
    UIAlertView *loginView;
    UITextField *loginUsernameField;
    UITextField *loginPassworField;
    UILabel *loginUserNameLabel;
    UILabel *loginPasswordLabel;
    */

    
    /*Crypto Buffers*/
    size_t cipherBufferSize;
    uint8_t *cipherBuffer;
    size_t plainBufferSize;
    uint8_t *plainBuffer;
    
    /*User credentials*/
    NSString *username;
    NSString *userPwd;
    
}

@end


@implementation messengerViewController

- (void)viewDidLoad
{
    NSLog(@"val is: %d",_appearCheck);
    /*Get Location*/
    [super viewDidLoad];
    
    locManager=[[CLLocationManager alloc] init];
    locManager.delegate=self;
    locManager.desiredAccuracy=kCLLocationAccuracyBest;
    locManager.distanceFilter=0.0f;
    if([CLLocationManager locationServicesEnabled])
    {
        [locManager startUpdatingLocation];
    }
    
    
    /*Start XML request*/
    recordResults=NO;
    NSURL *url=[NSURL URLWithString:@"http://localhost:8080/GroupMessagingApp/services/GroupsDataServiceService?wsdl"];
    NSMutableURLRequest *mutableURL = [NSMutableURLRequest requestWithURL:url];
    [mutableURL addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [mutableURL addValue:@"http://localhost:8080/GroupMessagingApp/services/GroupsDataServiceService?wsdl" forHTTPHeaderField:@"SOAPAction"];
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
    if(_appearCheck==0)
    {
        [self showLoginView];
    }
}

+(NSInteger)readFlag
{
   // return appearCheck;
}

+(void)setFlag:(NSInteger)flagVal
{
    //appearCheck=flagVal;
}

-(void)viewDidAppear:(BOOL)animated
{
    /*load up login view*/
    NSLog(@"check_flag: %d",_appearCheck);
    /*load up login view*/
    if(_appearCheck==0)
    {
        _appearCheck=1;
        loginViewController *loginVw=[[loginViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:loginVw animated:YES completion:NULL];
    }
}

-(void)showLoginView
{
        /*load up login view
    if(appearCheck==0)
    {
        NSLog(@"inside");
        appearCheck=1;
        UINavigationController *navigateView=[[UINavigationController alloc]init];
        [self.view addSubview:navigateView.view];
        loginViewController *loginVw=[[loginViewController alloc]initWithNibName:nil bundle:nil];
        [navigateView pushViewController:loginVw animated:YES];
        [loginVw release];
    }
    */ 
}



/*XML delegate methods*/
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [webData setLength:0];
    NSHTTPURLResponse * httpResponse;
    httpResponse = (NSHTTPURLResponse *) response;
    //NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);
    
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
    NSLog(@"parse started..");
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
    NSLog(@"parse found chars..");

	if(recordResults)
	{
		[soapResults appendString:string];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"parse results..");

	if([elementName isEqualToString:@"Symbol"] || [elementName isEqualToString:@"Last"] || [elementName isEqualToString:@"Time"] )
	{
		recordResults = NO;
		NSLog(@"SOAP Results: %@", soapResults);
		[soapResults release];
		soapResults = nil;
	}
}




/*Function calls*/


-(void) locationManager:(CLLocationManager*)locManager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*) oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 1.0)
    {
        NSString *showPos=[NSString stringWithFormat:@"lat: %f,long: %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude ];
        currLoc.text=showPos;
        NSLog(@"Current user position: %@",showPos);
        typedef double CLLocationDistance;
        CLLocationDistance dist = [oldLocation distanceFromLocation:newLocation];
        NSLog(@"distance moved: %f meters",(dist));
        NSString *distmoved=[NSString stringWithFormat:@"You just moved: %f meters",(dist)];
        distMoved.text=distmoved;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation); /*Only portrait supported*/
}



/*resign the keyboard on touching background*/
-(IBAction)backgroundTouched:(id)sender
{
    [messageVw resignFirstResponder];
}



-(IBAction)callEncrypt
{
    NSString *messageData;
    messageData=messageVw.text;
    [secureMessageRSA encryptMessage:messageData];
}

-(IBAction)callDecrypt
{
    [secureMessageRSA decryptMessage];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end