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
//#import "GroupsDataServiceServiceSvc.h"
//#import <Security/Security.h>
//#import <CommonCrypto/CommonCrypto.h>
//#import <CommonCrypto/CommonDigest.h>
//#import <MapKit/MapKit.h>
#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"

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
    NSLog(@"val is: %d",appearCheck);
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
            
}

-(void)viewDidAppear:(BOOL)animated
{
    /*load up login view*/
    NSLog(@"check_flag: %d",appearCheck);
    if(appearCheck==0)
    {
        appearCheck=1;
        loginViewController *loginVw=[[loginViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:loginVw animated:YES completion:NULL];
    }
}


/*SOAP request call*/
-(void)processRequest
{
    /*
    CurrencyConvertorSoapBinding* binding = [CurrencyConvertorSvc CurrencyConvertorSoapBinding];
    CurrencyConvertorSoapBindingResponse* response;
    CurrencyConvertorSvc_ConversionRate* request = [[CurrencyConvertorSvc_ConversionRate alloc]init];
    request.FromCurrency =  CurrencyConvertorSvc_Currency_enumFromString(@"USD");
    request.ToCurrency = CurrencyConvertorSvc_Currency_enumFromString(@"INR");
    response = [binding ConversionRateUsingParameters:request];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self processResponse:response];
    });
    */
    
    GroupsDataServiceServiceSoap11Binding *bindingSOAP=[GroupsDataServiceServiceSvc GroupsDataServiceServiceSoap11Binding];
    GroupsDataServiceServiceSoap11BindingResponse *bindingResponse;
    GroupsDataServiceServiceSvc_GetGroupsData *request=[[GroupsDataServiceServiceSvc_GetGroupsData alloc]init];
    request.UserId=username;
    bindingResponse=[bindingSOAP GetGroupsDataUsingParameters:request];
    NSLog(@"done processing request.. %@",bindingResponse);
    dispatch_async(dispatch_get_main_queue(), ^{[self processResponse:bindingResponse];});
    
}
 
/*SOAP response call*/
-(void)processResponse:(GroupsDataServiceServiceSoap11BindingResponse *)response
{
    /*
    NSArray *responseBodyParts = response.bodyParts;
    id bodyPart;    
    @try{
        bodyPart = [responseBodyParts objectAtIndex:0]; // Assuming just 1 part in response which is fine
        NSLog(@"type is: %@",bodyPart);
    }
    
    @catch (NSException* exception)
    {
        NSLog(@"err type is: %@",exception);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:@"Error while trying to process request" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([bodyPart isKindOfClass:[SOAPFault class]]) {
        
        NSString* errorMesg = ((SOAPFault *)bodyPart).simpleFaultString;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:errorMesg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if([bodyPart isKindOfClass:[CurrencyConvertorSvc_ConversionRateResponse class]]) {
        CurrencyConvertorSvc_ConversionRateResponse* rateResponse = bodyPart;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Currency Conversion Rate is %@",rateResponse.ConversionRateResult] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    */
    
    NSArray *responseBodyParts = response.bodyParts;
    NSLog(@"bodyparts: %@",responseBodyParts);
    id bodyPart;
    @try
    {
        bodyPart = [responseBodyParts objectAtIndex:0]; // Assuming just 1 part in response which is fine
        NSLog(@"type is: %@",bodyPart);
    }
    @catch (NSException* exception)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:@"Error while trying to process request" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([bodyPart isKindOfClass:[SOAPFault class]])
    {
        
        NSString* errorMesg = ((SOAPFault *)bodyPart).simpleFaultString;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:errorMesg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if([bodyPart isKindOfClass:[GroupsDataServiceServiceSvc_GetGroupsDataResponse class]])
    {
        GroupsDataServiceServiceSvc_GetGroupsDataResponse* groupResponse = bodyPart;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Response data is %@",groupResponse.return_] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];        
    } 
    
}


/*Setting the username received from loginView*/
-(void)getUserId:(NSString *)userId
{
    username=userId;
    NSLog(@"name is: %@",username);
}



/*Location update function calls*/

-(void) locationManager:(CLLocationManager*)locManager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 1.0)
    {
        NSString *showPos=[NSString stringWithFormat:@"lat: %f,long: %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude ];
        double latPos=newLocation.coordinate.latitude;
        double longPos=newLocation.coordinate.longitude;
        NSLog(@"Current user position: %@",showPos);
        /*
        typedef double CLLocationDistance;
        CLLocationDistance dist = [oldLocation distanceFromLocation:newLocation];
        NSLog(@"distance moved: %f meters",(dist));
        NSString *distmoved=[NSString stringWithFormat:@"You just moved: %f meters",(dist)];
        */
        
        
        /*Reverse Geo-coding*/
        NSString *urlLoc=[NSString stringWithFormat:kGeoCodingString,latPos,longPos];
        NSError *errMsg;
        NSString *locString=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlLoc] encoding:NSASCIIStringEncoding error:&errMsg];
        locString = [locString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"You're at: %@",[locString substringFromIndex:6]);
        messageVw.text=@"@ ";
        messageVw.text=[locString substringFromIndex:6];
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}



/*resign the keyboard on touching background*/
-(IBAction)backgroundTouched:(id)sender
{
    [messageVw resignFirstResponder];
}


/*show groups listing*/
-(IBAction)showGroups
{
    groupsTableViewViewController *tblView=[[groupsTableViewViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:tblView animated:YES completion:NULL];
    
}

/*show friends listing */
-(IBAction)showFriends
{
    NSLog(@"frineds will be shown soon..");
}

-(IBAction)postMessage
{
    NSString *messageData;
    messageData=messageVw.text;
    /*Call encryption routine to encrypt the message*/
    [secureMessageRSA encryptMessage:messageData];
    [secureMessageRSA decryptMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end