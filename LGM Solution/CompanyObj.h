//
//  CompanyObj.h
//  HurtLocker
//
//  Created by Phan Minh Tam on 10/8/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyObj : NSObject
{
    NSString *CompanyID;
    NSString *CompanyLogo;
    NSString *CompanyName;
}
@property (copy) NSString *CompanyID;
@property (copy) NSString *CompanyLogo;
@property (copy) NSString *CompanyName;
- (void) encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
- (id)initWithID:(NSString*)CompanyID
             CompanyLogo:(NSString*)CompanyLogo
             CompanyName:(NSString*)CompanyName;
@end
