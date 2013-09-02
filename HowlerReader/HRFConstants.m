//
//  HRFConstants.m
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFConstants.h"

@implementation HRFConstants

// GOOGLE FEED API URLS
NSString *const kGoogleFindChannelsBaseURL = @"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&num=100&q=";
NSString *const kGoogleLoadChannelBaseURL = @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=100&q=";


// Network Reachability realted

NSString *const kNetworkReachabilityNotificationName = @"networkReachabilityStatusChanged";
NSString *const kRandomURL = @"www.google.com";
NSString *const kNetworkReachable = @"networkReachable";
NSString *const kNetworkNotReachable = @"networkNotReachable";

// queried channels related
NSString *const kFindChannelDataUpdate = @"findChannelDataUpdate";
NSString *const kLoadChannelDataUpdate = @"loadChannelDataUpdate";

@end
