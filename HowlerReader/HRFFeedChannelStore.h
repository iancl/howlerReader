//
//  HRFFeedChannelStore.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRFFeedChannel;

@interface HRFFeedChannelStore : NSObject{
    NSMutableArray *_allFeedChannels;
}

// singleton
+(HRFFeedChannelStore *)sharedStore;

// add feedChannel
-(HRFFeedChannel *)addFeedChannel;

// add A feed channel
-(void)addAFeedChannel: (HRFFeedChannel *)feedChan;

// add feedChannel using array contents
-(void)addFeedChannelsUsingContentsOfArray: (NSArray *)theArray;

// get feedChannel by index
-(HRFFeedChannel *)feedChannelAtIndex: (int)theIndex;

// get store count
-(NSArray *)getAllFeedChannels;

// release all items
-(void)releaseAllFeedChannels;

@end
