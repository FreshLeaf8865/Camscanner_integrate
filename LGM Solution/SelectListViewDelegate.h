//
//  ContactVC.m
//  IDreminder
//
//  Created by Phan Minh Tam on 11/21/14.
//  Copyright (c) 2014 PMTam. All rights reserved.

#import <Foundation/Foundation.h>

@protocol SelectListViewDelegate <NSObject>
- (void)getSelected:(NSString*)selected onChosen:(NSString*)onChosen view:(UIView*)view;
@end
