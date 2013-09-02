//
//  HRFFavoriteChannelStore.m
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFFavoriteChannelStore.h"
#import "HRFFavoriteChannel.h"

@implementation HRFFavoriteChannelStore


-(id)init{
    self = [super init];
    
    if (self) {
        _allFavoriteChannels = [NSMutableDictionary dictionary];
    }
    
    return self;
}

// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

// singleton
+(HRFFavoriteChannelStore *)sharedStore{
    static HRFFavoriteChannelStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

// add favorite using key
-(void)setFavorite: (HRFFavoriteChannel *)favorite forKey: (NSString *)key{
    
    if ([favorite isKindOfClass:[HRFFavoriteChannel class]]) {
        [_allFavoriteChannels setObject:favorite forKey:key];
    }
}

// get favorite using key
-(HRFFavoriteChannel *)favoriteForKey: (NSString *)key{
    return [_allFavoriteChannels objectForKey:key];
}

// remove object using key
-(void)removeObjectForKey: (NSString *)key{
    [_allFavoriteChannels removeObjectForKey:key];
}

// get all favorites
-(NSArray *)allFavorites{
    return [_allFavoriteChannels allValues];
}


@end
