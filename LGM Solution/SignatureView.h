//
//  CameraView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureViewDelegate.h"
#import "GetSignature.h"

@interface SignatureView : UIView<GetSignatureDelegate>{
    UIImageView *image;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label alt:(NSString*)alt;
@property (nonatomic, retain) id<SignatureViewDelegate> delegate;
@end
