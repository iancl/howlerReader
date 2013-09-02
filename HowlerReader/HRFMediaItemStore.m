//
//  HRFMediaItemStore.m
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import "HRFMediaItemStore.h"
#import "HRFMediaItem.h"

@implementation HRFMediaItemStore

// prevents allocation of this class
+(id)allocWithZone:(NSZone *)zone{
    
    return [self sharedStore];
    
}

// singleton
+(HRFMediaItemStore *)sharedStore{
    
    static HRFMediaItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

// initialization
-(id)init{
    
    self = [super init];
    
    if (self) {
        _allMediaItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//adds a mediaItem returns its reference
-(HRFMediaItem *)addMediaItem{
    
    HRFMediaItem *mediaItem = [[HRFMediaItem alloc] init];
    
    [_allMediaItems addObject:mediaItem];
    
    return mediaItem;
    
}

// returns media item using index
-(HRFMediaItem *)mediaItemAtIndex: (int)theIndex{
    
    return [_allMediaItems objectAtIndex:theIndex];
}

// returns un mutable array of all media items
-(NSArray *)allMediaItems{
    return _allMediaItems;
}


// releases all items in store
-(void)releaseAllMediaItems{
    [_allMediaItems removeAllObjects];
}

@end
