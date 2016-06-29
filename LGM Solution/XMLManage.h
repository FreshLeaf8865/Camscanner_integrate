//
//  PartyParser.h
//  XMLTest
//
//  Created by Ray Wenderlich on 3/17/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyObj.h"

@interface XMLManage : NSObject {

}
+ (NSMutableArray*)loadCompanies:(NSString *)filePath;
+ (BOOL)getStatus:(NSString *)filePath;
+ (NSString*)getUsername:(NSString *)filePath;
+ (NSString*)getUseremail:(NSString *)filePath;
+ (NSString*)getEmail:(NSString *)filePath;
+ (NSMutableArray*)loadForm:(NSString *)filePath;
+ (NSMutableArray*)loadGroup:(NSString*)filePath;
@end
