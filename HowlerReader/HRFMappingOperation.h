//
//  HRFMappingOperation.h
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRFConstants.h"
#import "HRFProtocols.h"

@interface HRFMappingOperation : NSOperation

// Designated Initializer
-(id)initWithObjectType: (HRFObjectType)type dataDict: (NSDictionary *)dict;

@property (nonatomic) HRFObjectType targetObjectType;
@property (copy, nonatomic) NSDictionary *dictData;
@property (weak, nonatomic) id<HRFMappingOperationDelegate>delegate;

@end
