//
//  QrCodeView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/11/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QrCodeViewDelegate.h"
#import "ScaningView.h"

@interface QrCodeView : UIView<UITextFieldDelegate, ScaningViewDelegate>{
    UITextField *tf;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label;
@property (nonatomic, retain) id<QrCodeViewDelegate> delegate;
@end
