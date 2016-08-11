//
//  CameraView.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewDelegate.h"

@interface CameraView : UIView{
    UIImageView *image;
}
-(id)initWithRect:(CGRect)rect label:(NSString*)label;
@property (nonatomic, retain) id<CameraViewDelegate> delegate;
-(void) getImageSuccess:(NSNotification*)notif;
@end
