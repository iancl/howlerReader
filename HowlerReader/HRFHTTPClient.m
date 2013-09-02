//
//  HRFHTTPClient.m
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFHTTPClient.h"
#import "HRFConstants.h"
#import "HRFUtils.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@implementation HRFHTTPClient

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        // instantiate operation queues
        _findChannelsOperationQueue = [[NSOperationQueue alloc] init];
        _loadChannelsOperationQueue = [[NSOperationQueue alloc] init];
        
        
    }
    return self;
}

// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedClient];
}

// singleton
+(HRFHTTPClient *)sharedClient{
    static HRFHTTPClient *sharedClient = nil;
    
    if (!sharedClient) {
        sharedClient = [[super allocWithZone:nil] init];
    }
    
    return sharedClient;
} 

// create find channel request
-(void)findChannelsUsingKeywords:(NSString *)keywords{
    
    // show network activity indicator
    [[HRFUtils sharedUtils] showNetworkActivityIndicator];
    
    
    // create url and urlrequest
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGoogleFindChannelsBaseURL, keywords]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // use AFJSONRequestOperation instance to fetch data
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //hide network activity indicator
        [[HRFUtils sharedUtils] hideNetworkActivityIndicator];
        
        // notify search view of new updates
        [[NSNotificationCenter defaultCenter] postNotificationName:kFindChannelDataUpdate object:JSON];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //hide network activity indicator
        [[HRFUtils sharedUtils] hideNetworkActivityIndicator];
        
        // handle error
       
        
    }];
    
    [_findChannelsOperationQueue addOperation:operation];
    
}

// load feed channel using URL
-(void)loadRequestUsingStringUrl: (NSString *)feedUrl{
    
    // show network activity indicator
    [[HRFUtils sharedUtils] showNetworkActivityIndicator];
    
    
    // create url and urlrequest
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGoogleLoadChannelBaseURL, feedUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // use AFJSONRequestOperation instance to fetch data
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //hide network activity indicator
        [[HRFUtils sharedUtils] hideNetworkActivityIndicator];
        
        // notify search view of new updates
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadChannelDataUpdate object:JSON];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        //hide network activity indicator
        [[HRFUtils sharedUtils] hideNetworkActivityIndicator];
        
        // handleError
        NSLog(@"error feed");
        
    }];
    
    [_loadChannelsOperationQueue addOperation:operation];
    
}

// cancel all find requests
-(void)cancelAllFindRequests{
    [_findChannelsOperationQueue cancelAllOperations];
}

// cancel all load requests
-(void)cancelAllLoadRequests{
    [_loadChannelsOperationQueue cancelAllOperations];
}

// cancel all requests
-(void)cancelAllRequests{
    
    [self cancelAllFindRequests];
    [self cancelAllLoadRequests];
    
}

@end
