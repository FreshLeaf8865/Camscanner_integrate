//
//  ContactVC.m
//  IDreminder
//
//  Created by Phan Minh Tam on 11/21/14.
//  Copyright (c) 2014 PMTam. All rights reserved.

#import <Foundation/Foundation.h>

@protocol CameraViewDelegate <NSObject>
- (void)openCamera:(UIView*)view;
- (void)openGellary:(UIView*)view;

//MTPL: To set cam scan image for send mail
-(void)setCamScannerImage: (UIImage *)image;
@end
