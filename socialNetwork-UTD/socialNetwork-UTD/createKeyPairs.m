//
//  createKeyPairs.m
//  socialNetwork-UTD
//
//  Created by Ankit Malhotra on 04/11/12.
//  Copyright (c) 2012 Ankit Malhotra. All rights reserved.
//

#import "createKeyPairs.h"

@implementation createKeyPairs


-(void)generateKeyPairs
{
    NSLog(@"flag1..");
    static const UInt8 publicKeyIdentifier[] = "pubKey\0";
    static const UInt8 privateKeyIdentifier[] = "privKey\0";
    
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
    NSLog(@"flag2..");
    NSLog(@"%ld",status);
    
    if(privateKeyAttr) [privateKeyAttr release];
    if(publicKeyAttr) [publicKeyAttr release];
    if(keyPairAttr) [keyPairAttr release];
    if(publicKey) CFRelease(publicKey);
    if(privateKey) CFRelease(privateKey);
    
}
@end
