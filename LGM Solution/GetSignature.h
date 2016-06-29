//
//  GetSignature.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJRSignatureView.h"
#import "GetSignatureDelegate.h"
@interface GetSignature : UIView{
    
    __weak IBOutlet UIView *viewSignature;
    PJRSignatureView *signatureView;
}
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) id<GetSignatureDelegate> delegate;
- (void) showInView:(UIView*) superView;
- (void) hide;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickClear:(id)sender;
- (IBAction)clickCancel:(id)sender;
@end
