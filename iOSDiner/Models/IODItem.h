//
//  IODItem.h
//  iOSDiner
//
//  Created by David Guo on 12-8-29.
//  Copyright (c) 2012年 David Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IODItem : NSObject <NSCopying>
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) float price;
@property (nonatomic,strong) NSString* pictureFile;
- (id)initWithName:(NSString*)inName andPrice:(float)inPrice andPictureFile:(NSString*)inPictureFile;
+ (NSArray*)retrieveInventoryItems;
@end
