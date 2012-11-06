//
//  IODOrder.h
//  iOSDiner
//
//  Created by David Guo on 12-8-29.
//  Copyright (c) 2012年 David Guo. All rights reserved.
//
#import <Foundation/Foundation.h>

@class IODItem;

@interface IODOrder : NSObject

@property (nonatomic,strong) NSMutableDictionary* orderItems;

- (IODItem*)findKeyForOrderItem:(IODItem*)searchItem;
- (NSMutableDictionary *)orderItems;
- (NSString*)orderDescription;
- (void)addItemToOrder:(IODItem*)inItem;
- (void)removeItemFromOrder:(IODItem*)inItem;
- (float)totalOrder;
@end
