//
//  UserObj.h
//  SmarkKid
//
//  Created by Phan Minh Tam on 3/22/14.
//  Copyright (c) 2014 SDC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*============================================================================
 DECLARE CLASS NAME
 =============================================================================*/
@interface DataCenter : NSObject
{
}
//-(void)send_mail:(NSString*)name email:(NSString*)email to:(NSString*)to subject:(NSString*)subject content:(NSString*)content images:(NSMutableArray*)images;
-(void)send_mail:(NSString*)name to:(NSString*)to cc:(NSString*)cc subject:(NSString*)subject content:(NSString*)content images:(NSMutableArray*)images;
@end
