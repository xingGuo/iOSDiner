//
//  IODViewController.h
//  iOSDiner
//
//  Created by David Guo on 12-8-29.
//  Copyright (c) 2012年 David Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IODOrder;

@interface IODViewController : UIViewController {
    int currentItemIndex;
}

@property (strong, nonatomic) NSMutableArray* inventory;
@property (strong, nonatomic) IODOrder* order;
@property (weak, nonatomic) IBOutlet UIButton *ibRemoveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibAddItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibPreviousItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibNextItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibTotalOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *ibChalkboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibCurrentItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibCurrentItemLabel;
- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;
- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;

- (IBAction)ibaCalculateTotal:(id)sender;

- (void)updateCurrentInventoryItem;
- (void)updateInventoryButtons;
- (void)updateOrderBoard;
@end
