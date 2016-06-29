//
//  ContactVC.m
//  IDreminder
//
//  Created by Phan Minh Tam on 11/21/14.
//  Copyright (c) 2014 PMTam. All rights reserved.

#import <Foundation/Foundation.h>

@protocol RadioViewDelegate <NSObject>
-(void)clickYes:(UIView *)view;
-(void)clickNo:(UIView *)view;
@end
