//
//  messengerViewController.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "messengerViewController.h"
#import "messengerAppDelegate.h"
#import "loginViewController.h"
//#import "createKeyPairs.h"
#import <CoreLocation/CoreLocation.h>
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

/*key identifiers*/
static const UInt8 publicKeyIdentifier[] = "pubKey\0";
static const UInt8 privateKeyIdentifier[] = "privKey\0";

- (void)viewDidLoad
{
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
    NSURL *url=[NSURL URLWithString:@"http://localhost:8080/testConn/services/Converter?wsdl"];
    NSMutableURLRequest *mutableURL = [NSMutableURLRequest requestWithURL:url];
    [mutableURL addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [mutableURL addValue:@"http://localhost:8080/testConn/services/Converter?wsdl" forHTTPHeaderField:@"SOAPAction"];
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

-(void)viewDidAppear:(BOOL)animated
{
    /*load up login view*/
    if(appearCheck==0)
    {
        loginViewController *loginVw=[[loginViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:loginVw animated:YES completion:NULL];
        appearCheck=1;
    }
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


/*resign the keyboard on pressing return*/
-(IBAction)returnKeyBoard:(id)sender
{
    [sender resignFirstResponder];
}



-(IBAction)callEncrypt
{
    NSString *messageData;
    messageData=messageVw.text;
    [self encryptData:messageData];
}

-(IBAction)callDecrypt
{
    [self decryptData];
}

/*Generate pub/priv key pairs*/
-(void)generateKeyPairs
{    
    OSStatus status = noErr;
    
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
    
    
    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier
                                        length:strlen((const char *)publicKeyIdentifier)];
    NSData * privateTag = [NSData dataWithBytes:privateKeyIdentifier
                                         length:strlen((const char *)privateKeyIdentifier)];
    
    
    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;
    
    [keyPairAttr setObject:(id)kSecAttrKeyTypeRSA
                    forKey:(id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithInt:1024]
                    forKey:(id)kSecAttrKeySizeInBits];
    
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES]
                      forKey:(id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag
                      forKey:(id)kSecAttrApplicationTag];
    
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES]
                       forKey:(id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag
                       forKey:kSecAttrApplicationTag];
    
    [keyPairAttr setObject:privateKeyAttr
                    forKey:(id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr
                    forKey:(id)kSecPublicKeyAttrs];
    
    
    status=SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    NSLog(@"%ld",status);
    NSLog(@"pub: %@",(NSString *)publicKey);
    NSLog(@"priv: %@",(NSString *)privateKey);
    
    
    if(privateKeyAttr) [privateKeyAttr release];
    if(publicKeyAttr) [publicKeyAttr release];
    if(keyPairAttr) [keyPairAttr release];
    if(publicKey) CFRelease(publicKey);
    if(privateKey) CFRelease(privateKey);
    
}

-(void)encryptData:(NSString*)plainData
{
    OSStatus sanityCheck = noErr;
    int msgLength = [plainData length];
    uint8_t data[msgLength];
    for(int i=0;i<msgLength;i++)
    {
        data[i]=[plainData characterAtIndex:i] ;
    }
    SecKeyRef pubKey = NULL;      /*holds the pub key*/
    NSData *pubTag=[NSData dataWithBytes:publicKeyIdentifier length:strlen((const char *)publicKeyIdentifier)];
    
    NSMutableDictionary *pubKeyDict = [[NSMutableDictionary alloc]init];
    [pubKeyDict setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [pubKeyDict setObject:pubTag forKey:(id)kSecAttrApplicationTag];
    [pubKeyDict setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [pubKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
   
    /*copy the key from keychain to pubkey*/
    sanityCheck =
             SecItemCopyMatching((CFDictionaryRef)pubKeyDict,(CFTypeRef *)&pubKey);
    
    /*Allocate crypto buffer*/
    cipherBufferSize=SecKeyGetBlockSize(pubKey);
    cipherBuffer=malloc(cipherBufferSize);
    /*Start Encrypting*/
    sanityCheck=
        SecKeyEncrypt(pubKey, kSecPaddingPKCS1, data, sizeof(data), cipherBuffer, &cipherBufferSize);
    NSLog(@"Encrypted text: %s",cipherBuffer);
    
    if(pubKey) CFRelease(pubKey);
    if(pubKeyDict) CFRelease(pubKeyDict);
    //free(cipherBuffer);          /*transmit over network first & then free*/
}


-(void)decryptData
{
    OSStatus sanityCheck=noErr;
    
    SecKeyRef privKey=NULL;
    NSData *privTag=[[NSData alloc]initWithBytes:privateKeyIdentifier length:strlen((const char *)privateKeyIdentifier)];
    
    NSMutableDictionary *privKeyDict=[[NSMutableDictionary alloc]init];
    [privKeyDict setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [privKeyDict setObject:privTag forKey:(id)kSecAttrApplicationTag];
    [privKeyDict setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [privKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
    
    sanityCheck=
          SecItemCopyMatching((CFDictionaryRef)privKeyDict, (CFTypeRef *)&privKey);
    
    /*Allocate crypto buffer*/
    plainBufferSize=SecKeyGetBlockSize(privKey);
    plainBuffer=malloc(plainBufferSize);
    /*start decrypting*/
    sanityCheck=
          SecKeyDecrypt(privKey, kSecPaddingPKCS1, cipherBuffer, cipherBufferSize, plainBuffer, &plainBufferSize);
    
    NSLog(@"Decrypted text: %s",plainBuffer);
    free(cipherBuffer);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end