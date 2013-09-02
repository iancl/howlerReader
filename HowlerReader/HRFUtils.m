//
//  HRFUtils.m
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFUtils.h"
#import "HRFConstants.h"
#import <Reachability/Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>

@implementation HRFUtils

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //init flags
        _isNetworkActiivityIndicatorVisible = NO;
        _isReachabilityMonitorStarted = NO;
        
    }
    
    return self;
}


// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedUtils];
}

// singleton
+(HRFUtils *)sharedUtils{
    
    static HRFUtils *sharedUtils;
    
    if (!sharedUtils) {
        sharedUtils = [[super allocWithZone:nil] init];
    }
    
    return sharedUtils;
}

// shows activity indicator
-(void)showNetworkActivityIndicator{
    
    if (_isNetworkActiivityIndicatorVisible) return;
    
    _isNetworkActiivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

// void shows activity indicator
-(void)hideNetworkActivityIndicator{
    
    if (_isNetworkActiivityIndicatorVisible) {
        _isNetworkActiivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
}


// start monitoring for network rechability
-(void)startReachabilityMonitor{
    
    // prevent from starting more than once
    if (_isReachabilityMonitorStarted) return;
    
    // reachability monitor will start now
    _isReachabilityMonitorStarted = YES;
    
    
    Reachability *reach = [Reachability reachabilityWithHostname:kRandomURL];
    
    // set reachable blocks
    reach.reachableBlock = ^(Reachability *reach){
        
        // send notification to let know that the network is reachable
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityNotificationName object:kNetworkReachable];
        NSLog(@"network reachable");
    };
    
    // set unreachable block
    reach.unreachableBlock = ^(Reachability *reach){
        
        // send notification to let know that the network is not reachable
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityNotificationName object:kNetworkNotReachable];
        NSLog(@"network not reachable");
    };
    
    
    //start reachability notifier. Object will retain itself
    [reach startNotifier];
}

// will return a unique UUID string
-(NSString *)generateUUID{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef uuidStringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    
    NSString *str = (__bridge NSString *)uuidStringRef;
    
    CFRelease(uuidRef);
    CFRelease(uuidStringRef);
    
    return str;
}


// strip html characters
// returns a string without any html tag
-(NSString *) stringByStrippingHTML: (NSString *)str{
    NSRange r;
    
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

// will encode special characters to URL standard
-(NSString *)URLEncodeForString: (NSString *)str{
    
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) str,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    
    
    return escapedString;
}


@end
