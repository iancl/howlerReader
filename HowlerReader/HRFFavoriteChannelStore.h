//
//  HRFFavoriteChannelStore.h
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRFFavoriteChannel;

@interface HRFFavoriteChannelStore : NSObject{
    NSMutableDictionary *_allFavoriteChannels;
}

// singleton
+(HRFFavoriteChannelStore *)sharedStore;

// add favorite using key
-(void)setFavorite: (HRFFavoriteChannel *)favorite forKey: (NSString *)key;

// get favorite using key
-(HRFFavoriteChannel *)favoriteForKey: (NSString *)key;

// remove object using key
-(void)removeObjectForKey: (NSString *)key;

//get all favorites
-(NSArray *)allFavorites;

@end
