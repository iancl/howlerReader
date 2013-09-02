//
//  HRFFeedChannel.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRFChannel.h"

@interface HRFFeedChannel : HRFChannel

@property (nonatomic, copy) NSString *feedURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *itemKey;

@end
