//
//  messengerViewController.h
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 10/10/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface messengerViewController : UIViewController
{
    IBOutlet UILabel *currLoc;
    IBOutlet UILabel *distMoved;
    IBOutlet UIButton *encryptBtn;
    IBOutlet UIButton *decryptBtn;
    IBOutlet UITextView *messageVw;
    @public NSInteger appearCheck;
}

@property(readwrite,assign)NSInteger appearCheck;

-(IBAction)backgroundTouched:(id)sender;
-(void)showLoginView;
+(void)setFlag:(NSInteger)flagVal;
+(NSInteger)readFlag;
-(IBAction)callEncrypt;
-(IBAction)callDecrypt;


@end
