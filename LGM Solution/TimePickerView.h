//
//  TimePickerView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerViewDelegate.h"
#import "TimePicker.h"

@interface TimePickerView : UIView<TimePickerDelegate>{
    UILabel *lbValue;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label;
@property (nonatomic, retain) id<TimePickerViewDelegate> delegate;
@end
