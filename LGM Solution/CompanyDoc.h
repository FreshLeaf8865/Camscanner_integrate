//
//  CompanyDoc.h
//  HurtLocker
//
//  Created by Phan Minh Tam on 10/8/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyObj.h"
#import <UIKit/UIKit.h>

@interface CompanyDoc : NSObject{
    CompanyObj *_data;
    UIImage *_thumbImage;
    NSData *_xmlFile;
    NSString *_docPath;
}
@property (retain) CompanyObj *data;
@property (retain) UIImage *thumbImage;
@property (retain) NSData *xmlFile;
@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)saveImages;
- (void)deleteDoc;
- (id)initWithID:(NSString*)CompanyID
     CompanyLogo:(NSString *)CompanyLogo
     CompanyName:(NSString *)CompanyName
      thumbImage:(UIImage *)thumbImage
        xmlFile:(NSData *)xmlFile;
@end
