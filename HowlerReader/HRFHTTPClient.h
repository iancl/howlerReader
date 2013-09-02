//
//  HRFHTTPClient.h
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFHTTPClient : NSObject{
    NSOperationQueue *_findChannelsOperationQueue;
    NSOperationQueue *_loadChannelsOperationQueue;
}

// singleton
+(HRFHTTPClient *)sharedClient;

// create find channel request and adds it to find queue
-(void)findChannelsUsingKeywords: (NSString *)keywords;

// load feed channel using URL
-(void)loadRequestUsingStringUrl: (NSString *)feedUrl;


// cancel all find requests
-(void)cancelAllFindRequests;

// cancel all find requests
-(void)cancelAllLoadRequests;

// cancel all requests
-(void)cancelAllRequests;

@end
