//
//  HRFFeedChannelStore.m
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import "HRFFeedChannelStore.h"
#import "HRFFeedChannel.h"

@implementation HRFFeedChannelStore

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //init array
        _allFeedChannels = [NSMutableArray array];
        
    }
    
    return self;
}

// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

// singleton
+(HRFFeedChannelStore *)sharedStore{
    
    static HRFFeedChannelStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

// add feedChannel
-(HRFFeedChannel *)addFeedChannel{
    
    HRFFeedChannel *feedChannel = [[HRFFeedChannel alloc] init];
    
    [_allFeedChannels addObject:feedChannel];
    
    return feedChannel;
}

// add A feed channel
-(void)addAFeedChannel: (HRFFeedChannel *)feedChan{
    
    
    if ([feedChan isMemberOfClass:[HRFFeedChannel class]]) {
        
        [_allFeedChannels addObject:feedChan];
    }
    
}

// add feedChannel using array contents
-(void)addFeedChannelsUsingContentsOfArray: (NSArray *)theArray{
    
    for (int i=0; i < [theArray count]; i++) {
        
        HRFFeedChannel *feedChannel = [theArray objectAtIndex:i];
        
        // raise exception if the current array item is not an HRFQueriedChannel
        if (![feedChannel isKindOfClass:[HRFFeedChannel class]]) {
            [NSException raise:@"invalid Object in array" format:@"array items must be HRFFeedChannel instances"];
        }
        
        // add item to channels array
        [_allFeedChannels addObject:feedChannel];
    }
}

// get feedChannel by index
-(HRFFeedChannel *)feedChannelAtIndex: (int)theIndex{
    
    return [_allFeedChannels objectAtIndex:theIndex];
    
}

// get all items
-(NSArray *)getAllFeedChannels{
    return _allFeedChannels;
}

// release all items
-(void)releaseAllFeedChannels{
    [_allFeedChannels removeAllObjects];
}


@end
