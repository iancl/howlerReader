//
//  HRFConstants.h
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFConstants : NSObject

// GOOGLE FEED API URLS
extern NSString *const kGoogleFindChannelsBaseURL;
extern NSString *const kGoogleLoadChannelBaseURL;

// network reachability realted
extern NSString *const kRandomURL;
extern NSString *const kNetworkReachabilityNotificationName;
extern NSString *const kNetworkReachable;
extern NSString *const kNetworkNotReachable;


// queried channels related
extern NSString *const kFindChannelDataUpdate;
extern NSString *const kLoadChannelDataUpdate;

// object types
typedef const enum {
    kQueriedChannelObjectType = 0,
    kFeedChannelObjectType = 1
} HRFObjectType;

@end
