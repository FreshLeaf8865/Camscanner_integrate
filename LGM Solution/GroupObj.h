//
//  GroupObj.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/8/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupObj : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *forms;
@property (nonatomic, assign) int tagOfParent;
@property (nonatomic, retain) id classOfParrent;
@end
