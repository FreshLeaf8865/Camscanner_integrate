//
//  ScaningView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/11/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ScaningViewDelegate.h"

@interface ScaningView : UIView<AVCaptureMetadataOutputObjectsDelegate>{
    NSString *dataScan;
    CGPoint velocityF;
    CGPoint velocityL;
}
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) id<ScaningViewDelegate> delegate;
- (void) showInView:(UIView*) superView;
- (void) hide;


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;
@end
