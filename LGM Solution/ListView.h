//
//  TimePickerView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewDelegate.h"
#import "AddItem.h"
#import "ItemCell.h"

@interface ListView : UIView<AddItemDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *arrData;
    UITableView *tbView;
    
    __weak IBOutlet ItemCell *homeCell;
    UIView *line;
    UILabel *lbNodata;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label arr:(NSMutableArray*)arr;
@property (nonatomic, retain) id<ListViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *arrForms;
- (IBAction)clickDelete:(id)sender;
@end
