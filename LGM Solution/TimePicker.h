//
//  TimePicker.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerDelegate.h"

@interface TimePicker : UIView{
    
    __weak IBOutlet UIButton *bt30;
    __weak IBOutlet UIButton *bt15;
    __weak IBOutlet UIButton *bt5;
    __weak IBOutlet UIButton *bt1;
    __weak IBOutlet UIDatePicker *dateTimePic;
    NSString *time;
    
}
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) id<TimePickerDelegate> delegate;
@property (nonatomic , assign) NSString *time;
- (void) showInView:(UIView*) superView;
- (void) hide;
- (IBAction)clickDone:(id)sender;
- (IBAction)clickNow:(id)sender;
- (IBAction)clickCancel:(id)sender;

- (IBAction)click30:(id)sender;
- (IBAction)click15:(id)sender;
- (IBAction)click5:(id)sender;
- (IBAction)click1:(id)sender;

@end
