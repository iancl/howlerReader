//
//  HRFQueriedChannel.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/9/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRFChannel.h"

@interface HRFQueriedChannel : HRFChannel


@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * contentSnippet;

@end
