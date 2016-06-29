//
//  DetailObject.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/25/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailObject : NSObject

@property (nonatomic, retain) NSString *CompanyID;
@property (nonatomic, retain) NSString *CompanyName;
@property (nonatomic, retain) UIImage  *CompanyLogo;
@property (nonatomic, retain) NSString *MailAddress;
@property (nonatomic, retain) NSMutableArray *Form;
@property (nonatomic, retain) NSMutableArray *Group;

@end
