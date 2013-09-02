//
//  HRFUtils.h
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface HRFUtils : NSObject{
    
    // will be used to let know if indicator is visible
    BOOL _isNetworkActiivityIndicatorVisible;
    BOOL _isReachabilityMonitorStarted;
    
    // HUD loading indicator
    MBProgressHUD *_loadingIndicator;
}

// singleton
+(HRFUtils *)sharedUtils;

// shows network activity indicator
-(void)showNetworkActivityIndicator;

// hides network activity indicator
-(void)hideNetworkActivityIndicator;

// start monitoring for network rechability
-(void)startReachabilityMonitor;

// will return a unique UUID string
-(NSString *)generateUUID;

// strip html characters
// returns a string without any html tag
-(NSString *) stringByStrippingHTML: (NSString *)str;

// will encode special characters to URL standard
// returns url encoded string
-(NSString *)URLEncodeForString: (NSString *)str;

@end
