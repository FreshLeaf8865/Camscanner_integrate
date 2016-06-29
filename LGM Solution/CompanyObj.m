//
//  CompanyObj.m
//  HurtLocker
//
//  Created by Phan Minh Tam on 10/8/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import "CompanyObj.h"

@implementation CompanyObj
@synthesize CompanyID = _CompanyID;
@synthesize CompanyLogo = _CompanyLogo;
@synthesize CompanyName = _CompanyName;

- (id)initWithID:(NSString*)CompanyID
             CompanyLogo:(NSString*)CompanyLogo
             CompanyName:(NSString*)CompanyName{
    if ((self = [super init])) {
        _CompanyID = [CompanyID copy];
        _CompanyLogo = [CompanyLogo copy];
        _CompanyName = [CompanyName copy];
    }
    return self;
}

- (void)dealloc {
    [_CompanyID release];
    _CompanyID = nil;
    [_CompanyLogo release];
    _CompanyLogo = nil;
    [_CompanyName release];
    _CompanyName = nil;
    
}
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_CompanyID forKey:@"CompanyID"];
    [encoder encodeObject:_CompanyLogo forKey:@"CompanyLogo"];
    [encoder encodeObject:_CompanyName forKey:@"CompanyName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString * s1 = [decoder decodeObjectForKey:@"CompanyID"];
    NSString * s2 = [decoder decodeObjectForKey:@"CompanyLogo"];
    NSString * s3 = [decoder decodeObjectForKey:@"CompanyName"];
    return [self initWithID:s1 CompanyLogo:s2 CompanyName:s3];
}
@end
