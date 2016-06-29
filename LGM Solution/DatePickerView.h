//
//  TimePickerView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewDelegate.h"

@interface DatePickerView : UIView{
    UILabel *lbValue;
    NSString *lbel;;
    NSString *dateSelected;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label;
@property (nonatomic, retain) id<DatePickerViewDelegate> delegate;
@end
