//
//  IODOrder.m
//  iOSDiner
//
//  Created by David Guo on 12-8-29.
//  Copyright (c) 2012年 David Guo. All rights reserved.
//

#import "IODOrder.h"
#import "IODItem.h"
@implementation IODOrder
@synthesize orderItems;

- (NSMutableDictionary *)orderItems{
    if (!orderItems) {
        orderItems = [NSMutableDictionary new];
    }
    return orderItems;
}

- (IODItem*)findKeyForOrderItem:(IODItem*)searchItem {
	// 1 - Find the matching item index
    NSIndexSet* indexes = [[self.orderItems allKeys] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        IODItem* key = obj;
        return [searchItem.name isEqualToString:key.name] &&
        searchItem.price == key.price;
    }];
	// 2 - Return first matching item
    if ([indexes count] >= 1) {
        IODItem* key = [[self.orderItems allKeys] objectAtIndex:[indexes firstIndex]];
        return key;
    }
	// 3 - If nothing is found
    return nil;
}
- (NSString*)orderDescription {
	// 1 - Create description string
    NSMutableString* orderDescription = [NSMutableString new];
	// 2 - Sort the order items by name
    NSArray* keys = [[self.orderItems allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        IODItem* item1 = (IODItem*)obj1;
        IODItem* item2 = (IODItem*)obj2;
        return [item1.name compare:item2.name];
    }];
	// 3 - Enumerate items and add item name and quantity to description
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IODItem* item = (IODItem*)obj;
        NSNumber* quantity = (NSNumber*)[self.orderItems objectForKey:item];
        [orderDescription appendFormat:@"%@ x%@n", item.name, quantity];
    }];
	// 4 - Return order description
    return [orderDescription copy];
}

- (void)addItemToOrder:(IODItem*)inItem {
	// 1 - Find item in order list
    IODItem* key = [self findKeyForOrderItem:inItem];
	// 2 - If the item doesn't exist, add it
    if (!key) {
        [self.orderItems setObject:[NSNumber numberWithInt:1] forKey:inItem];
    } else {
		// 3 - If item exists, update the quantity
        NSNumber* quantity = [self.orderItems objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity++;
		// 4 - Update order items list with new quantity
        [self.orderItems removeObjectForKey:key];
        [self.orderItems setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
    }
}

- (void)removeItemFromOrder:(IODItem*)inItem {
	// 1 - Find the item in order list
    IODItem* key = [self findKeyForOrderItem:inItem];
	// 2 - We remove the item only if it exists
    if (key) {
		// 3 - Get the quanity and decrement by one
        NSNumber* quantity = [[self orderItems] objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity--;
		// 4 - Remove object from array
        [[self orderItems] removeObjectForKey:key];
		// 5 - Add a new object with updated quantity only if quantity > 0
        if (intQuantity > 0)
            [[self orderItems] setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
    }
}

- (float)totalOrder {
    __block float total = 0.0;
    float (^itemTotal)(float,int) = ^float(float price, int quantity) {
        return price * quantity;
    };
    
    [[self orderItems] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        IODItem* item = (IODItem*)key;
        NSNumber* quantity = (NSNumber*)obj;
        int intQuantity = [quantity intValue];
        
        total += itemTotal([item price],intQuantity);
    }];
    
    return total;
}

@end
