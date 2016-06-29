//
//  CompanyDatabase.h
//  HurtLocker
//
//  Created by Phan Minh Tam on 10/8/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDatabase : NSObject

+ (NSMutableArray *)loadScaryBugDocsCompany;
+ (NSString *)nextScaryBugDocPathCompany;
@end
