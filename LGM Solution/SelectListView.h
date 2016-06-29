//
//  SelectListView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectListViewDelegate.h"

@interface SelectListView : UIView{
    NSString *lbel;
    NSArray *arrData;
    NSArray *arrOnchoose;
    UIButton *bt;
    int indexSelected;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label arr:(NSMutableArray*)arr;
@property (nonatomic, retain) id<SelectListViewDelegate> delegate;
@end
