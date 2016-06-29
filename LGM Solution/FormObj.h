//
//  FormObj.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/5/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormObj : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *validate;
@property (nonatomic, retain) NSString *alt;
@property (nonatomic, retain) NSString *isEmpty;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *select;
@property (nonatomic, retain) NSMutableArray *radio;

@end
