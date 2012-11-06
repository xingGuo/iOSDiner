//
//  IODViewController.m
//  iOSDiner
//
//  Created by David Guo on 12-8-29.
//  Copyright (c) 2012年 David Guo. All rights reserved.
//

#import "IODViewController.h"
#import "IODItem.h"      // <---- #1
#import "IODOrder.h"     // <---- #1

@interface IODViewController ()

@end

@implementation IODViewController
@synthesize ibRemoveItemButton;
@synthesize ibAddItemButton;
@synthesize ibPreviousItemButton;
@synthesize ibNextItemButton;
@synthesize ibTotalOrderButton;
@synthesize ibChalkboardLabel;
@synthesize ibCurrentItemImageView;
@synthesize ibCurrentItemLabel;
@synthesize inventory;     // <---- #2
@synthesize order;         // <---- #2

dispatch_queue_t queue;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)dealloc {
    dispatch_release(queue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentItemIndex = 0;            // <---- #3
    self.order = [IODOrder new];     // <---- #4
    queue = dispatch_queue_create("com.adamburkepile.queue",nil);
}

- (void)viewDidUnload
{
    [self setIbRemoveItemButton:nil];   
    [self setIbAddItemButton:nil];
    [self setIbPreviousItemButton:nil];
    [self setIbNextItemButton:nil];
    [self setIbTotalOrderButton:nil];
    [self setIbChalkboardLabel:nil];
    [self setIbCurrentItemImageView:nil];
    [self setIbCurrentItemLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)ibaRemoveItem:(id)sender {
    IODItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    UILabel* removeItemDisplay = [[UILabel alloc] initWithFrame:ibCurrentItemImageView.frame];
    [removeItemDisplay setCenter:ibChalkboardLabel.center];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:UITextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [removeItemDisplay setCenter:[ibCurrentItemImageView center]];
                         [removeItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [removeItemDisplay removeFromSuperview];
                     }];
    
}

- (IBAction)ibaAddItem:(id)sender {
    IODItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    UILabel* addItemDisplay = [[UILabel alloc] initWithFrame:ibCurrentItemImageView.frame];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:UITextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [addItemDisplay setCenter:ibChalkboardLabel.center];
                         [addItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [addItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaLoadPreviousItem:(id)sender {
    currentItemIndex--;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];

}

- (IBAction)ibaLoadNextItem:(id)sender {
    currentItemIndex++;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaCalculateTotal:(id)sender {
    float total = [order totalOrder];
    
    UIAlertView* totalAlert = [[UIAlertView alloc] initWithTitle:@"Total"
                                                         message:[NSString stringWithFormat:@"$%0.2f",total]
                                                        delegate:nil
                                               cancelButtonTitle:@"Close"
                                               otherButtonTitles:nil];
    [totalAlert show];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
    
    [self updateInventoryButtons];// <---- Add
    
    [ibChalkboardLabel setText:@"Loading Inventory..."];//开始变化
  
	dispatch_async(queue, ^{
		self.inventory = [[IODItem retrieveInventoryItems] mutableCopy];
        
		dispatch_async(dispatch_get_main_queue(), ^{
			[self updateOrderBoard]; // <---- Add
			[self updateInventoryButtons];
			[self updateCurrentInventoryItem];
			ibChalkboardLabel.text = @"Inventory LoadednnHow can I help you?";
		});
	});

}

- (void)updateCurrentInventoryItem {
    if (currentItemIndex >= 0 && currentItemIndex < [self.inventory count]) {
        IODItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
        ibCurrentItemLabel.text = currentItem.name;
        ibCurrentItemImageView.image = [UIImage imageNamed:[currentItem pictureFile]];
    }
}

- (void)updateInventoryButtons {
    if (!self.inventory || [self.inventory count] == 0) {
        ibAddItemButton.enabled = NO;
        ibRemoveItemButton.enabled = NO;
        ibNextItemButton.enabled = NO;
        ibPreviousItemButton.enabled = NO;
        ibTotalOrderButton.enabled = NO;
    } else {
        if (currentItemIndex <= 0) {
            ibPreviousItemButton.enabled = NO;
        } else {
            ibPreviousItemButton.enabled = YES;
        }
        if (currentItemIndex >= [self.inventory count]-1) {
            ibNextItemButton.enabled = NO;
        } else {
            ibNextItemButton.enabled = YES;
        }
        IODItem* currentItem = [self.inventory objectAtIndex:currentItemIndex];
        if (currentItem) {
            ibAddItemButton.enabled = YES;
        } else {
            ibAddItemButton.enabled = NO;
        }
        if (![self.order findKeyForOrderItem:currentItem]) {
            ibRemoveItemButton.enabled = NO;
        } else {
            ibRemoveItemButton.enabled = YES;
        }
        if ([order.orderItems count] == 0) {
            ibTotalOrderButton.enabled = NO;
        } else {
            ibTotalOrderButton.enabled = YES;
        }
    }
}

- (void)updateOrderBoard {
    if ([order.orderItems count] == 0) {
        ibChalkboardLabel.text = @"No Items. Please order something!";
    } else {
        ibChalkboardLabel.text = [order orderDescription];
    }
}


@end
