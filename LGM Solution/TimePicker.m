//
//  TimePicker.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "TimePicker.h"

@implementation TimePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showInView:(UIView*) superView
{
    UIView *view = [[UIView alloc] initWithFrame:superView.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [view addSubview:self];
    //    [superView addSubview:view];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:view];
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.center = CGPointMake(superView.center.x, superView.center.y+12);
    view.frame = window.frame;
    view.center = window.center;
    view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    
    view.alpha = 1.0;
    
    [UIView commitAnimations];
    
    self.maskView = view;
    
    [dateTimePic addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 15;
    if (![_time isEqualToString:@"No time available"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        [dateTimePic setDate:[formatter dateFromString:_time]];
    }
    
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    time = [formatter stringFromDate:datePicker.date];
}
- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0;
    } completion:^(BOOL finished)
     {
         [_maskView removeFromSuperview];
         [self removeFromSuperview];
     }];
}
- (IBAction)clickDone:(id)sender {
    [self hide];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    time = [formatter stringFromDate:dateTimePic.date];
    [_delegate clickDone:time];
}

- (IBAction)clickNow:(id)sender {
    
    [dateTimePic setDate:[NSDate date]];
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 1;
}

- (IBAction)clickCancel:(id)sender {
    [self hide];
}

- (IBAction)click30:(id)sender {
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 30;
}

- (IBAction)click15:(id)sender {
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 15;
}

- (IBAction)click5:(id)sender {
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 5;
}

- (IBAction)click1:(id)sender {
    [bt1 setBackgroundImage:[UIImage imageNamed:@"bt_ok.png"] forState:UIControlStateNormal];
    
    [bt30 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt5 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    [bt15 setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
    
    dateTimePic.minuteInterval = 1;
}
@end
