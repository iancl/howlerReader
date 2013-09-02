//
//  HRFQueriedChannelStore.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRFQueriedChannel;

@interface HRFQueriedChannelStore : NSObject{
    
    NSMutableArray *_allQueriedChannels;
}

@property (copy, nonatomic) NSString *lastSearchName;

// singleton
+(HRFQueriedChannelStore *)sharedStore;

// add queriedChannel
-(HRFQueriedChannel *)addQueriedChannel;

// add queriedChannel using array contents
-(void)addQueriedChannelsUsingContentsOfArray: (NSArray *)theArray;

// get queried channel by index
-(HRFQueriedChannel *)queriedChannelAtIndex: (int)theIndex;

// get store count
-(NSArray *)allQueriedChannels;

// getAllItems
-(void)releaseAllQueriedChannels;

@end
