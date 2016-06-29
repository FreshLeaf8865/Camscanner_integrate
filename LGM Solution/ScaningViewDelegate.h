//
//  ContactVC.m
//  IDreminder
//
//  Created by Phan Minh Tam on 11/21/14.
//  Copyright (c) 2014 PMTam. All rights reserved.

#import <Foundation/Foundation.h>

@protocol ScaningViewDelegate <NSObject>
- (void)resultScan:(NSString*)text;
@end
