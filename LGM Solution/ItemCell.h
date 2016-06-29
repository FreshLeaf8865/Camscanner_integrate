//
//  ItemCell.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgDelete;
@property (nonatomic, retain) NSMutableArray *arrText;
@end
