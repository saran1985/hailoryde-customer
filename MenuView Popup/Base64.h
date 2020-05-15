//
//  Base64.h
//  Tibs-Taxi-Customer
//
//  Created by Admin on 02/11/18.
//  Copyright © 2018 BLYNC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject {
    
}

+ (void) initialize;

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;

+ (NSString*) encode:(NSData*) rawBytes;

+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;

+ (NSData*) decode:(NSString*) string;

@end
