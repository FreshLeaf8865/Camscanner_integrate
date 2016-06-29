//
//  UIAlertView+NSBlock.h
//  HurtLocker
//
//  Created by PMT on 9/24/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NSBlock)
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;
@end
