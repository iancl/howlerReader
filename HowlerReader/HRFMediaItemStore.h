//
//  HRFMediaItemStore.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRFMediaItem;

@interface HRFMediaItemStore : NSObject{
    
    NSMutableArray *_allMediaItems;
}

+(HRFMediaItemStore *)sharedStore;

-(HRFMediaItem *)addMediaItem;

-(HRFMediaItem *)mediaItemAtIndex: (int)theIndex;

-(NSArray *)allMediaItems;

-(void)releaseAllMediaItems;

@end
