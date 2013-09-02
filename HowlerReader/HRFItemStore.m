//
//  HRFItemStore.m
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import "HRFItemStore.h"

@implementation HRFItemStore

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //init array
        _allItems = [NSMutableArray array];
        
    }
    
    return self;
}

// override alloc with zone to ensure only 1 instance will be created
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

// singleton
+(HRFItemStore *)sharedStore{
    static HRFItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

// add item
-(HRFItem *)addItem{
    
    HRFItem *item = [[HRFItem alloc] init];
    
    [_allItems addObject:item];
    
    return item;
}

// get item by index
-(HRFItem *)itemAtIndex: (int)theIndex{
    
    return [_allItems objectAtIndex:theIndex];
}

// get store count
-(NSArray *)allItems{
    
    return _allItems;
}

// getAllItems
-(void)releaseAllItems{
    
    [_allItems removeAllObjects];
}

@end
