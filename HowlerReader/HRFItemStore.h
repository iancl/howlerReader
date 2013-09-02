//
//  HRFItemStore.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRFItem.h"


@interface HRFItemStore : NSObject{
    NSMutableArray *_allItems;
}

// singleton
+(HRFItemStore *)sharedStore;

// add item
-(HRFItem *)addItem;

// get item by index
-(HRFItem *)itemAtIndex: (int)theIndex;

// get store count
-(NSArray *)allItems;

// getAllItems
-(void)releaseAllItems;

@end
