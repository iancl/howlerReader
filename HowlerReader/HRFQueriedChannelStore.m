//
//  HRFQueriedChannelStore.m
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import "HRFQueriedChannelStore.h"
#import "HRFQueriedChannel.h"

@implementation HRFQueriedChannelStore
@synthesize lastSearchName = _lastSearchName;

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //init array
        _allQueriedChannels = [NSMutableArray array];
        
    }
    
    return self;
}

// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

// singleton
+(HRFQueriedChannelStore *)sharedStore{
    
    static HRFQueriedChannelStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

// add queriedChannel
-(HRFQueriedChannel *)addQueriedChannel{
    
    HRFQueriedChannel *queriedChannel = [[HRFQueriedChannel alloc] init];
    
    [_allQueriedChannels addObject:queriedChannel];
    
    return queriedChannel;
}

// add queriedChannel using array contents
-(void)addQueriedChannelsUsingContentsOfArray: (NSArray *)theArray{
    
    for (int i=0; i < [theArray count]; i++) {
        
        HRFQueriedChannel *queriedChannel = [theArray objectAtIndex:i];
        
        // raise exception if the current array item is not an HRFQueriedChannel
        if (![queriedChannel isKindOfClass:[HRFQueriedChannel class]]) {
            [NSException raise:@"invalid Object in array" format:@"array items must be HRFQueriedChannel instances"];
        }
        
        // add item to channels array
        [_allQueriedChannels addObject:queriedChannel];
    }
}

// get queried channel by index
-(HRFQueriedChannel *)queriedChannelAtIndex: (int)theIndex{
    
    return [_allQueriedChannels objectAtIndex:theIndex];
    
}

// get all items
-(NSArray *)allQueriedChannels{
    return _allQueriedChannels;
}

// release all items
-(void)releaseAllQueriedChannels{
    _allQueriedChannels = nil;
    _allQueriedChannels = [NSMutableArray array];
}

@end
