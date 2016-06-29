//
//  ControlPosition.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/8/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControlPosition : NSObject
@property (nonatomic, retain) id classOfControl;
@property (nonatomic, assign) CGFloat yOfControl;
@property (nonatomic, assign) int tagOfControl;
@property (nonatomic, assign) int tagOfParrentControl;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *stringOfRadio;
@property (nonatomic, retain) NSString *isEmpty;
@property (nonatomic, retain) UIImage *image;
@end
