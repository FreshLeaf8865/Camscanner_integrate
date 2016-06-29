//
//  GetSignature.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "GetSignature.h"
#import "Define.h"
#import "Common.h"

@implementation GetSignature

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
    
    self.center = CGPointMake(superView.center.x, superView.center.y);
    view.frame = window.frame;
    view.center = window.center;
    view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    
    view.alpha = 1.0;
    
    [UIView commitAnimations];
    
    self.maskView = view;
    signatureView= [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 0, viewSignature.frame.size.width, viewSignature.frame.size.height)];
    [viewSignature addSubview:signatureView];
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
- (IBAction)clickSave:(id)sender {
    [_delegate clickOKSignature:[signatureView getSignatureImage]];
    [self hide];
}

- (IBAction)clickClear:(id)sender {
    [signatureView clearSignature];
}

- (IBAction)clickCancel:(id)sender {
    [self hide];
}
@end
