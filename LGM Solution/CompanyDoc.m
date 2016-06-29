//
//  CompanyDoc.m
//  HurtLocker
//
//  Created by Phan Minh Tam on 10/8/14.
//  Copyright (c) 2015 X-TECH creative studio. All rights reserved.
//

#import "CompanyDoc.h"
#import "CompanyDatabase.h"
#import "CompanyObj.h"
#import "Define.h"


@implementation CompanyDoc
@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize xmlFile = _xmlFile;
@synthesize docPath = _docPath;
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (id)initWithID:(NSString *)CompanyID CompanyLogo:(NSString *)CompanyLogo CompanyName:(NSString *)CompanyName thumbImage:(UIImage *)thumbImage xmlFile:(NSData *)xmlFile{
    if ((self = [super init])) {
        _data = [[CompanyObj alloc] initWithID:CompanyID CompanyLogo:CompanyLogo CompanyName:CompanyName];
        _thumbImage = [thumbImage retain];
        _xmlFile = [xmlFile retain];
    }
    return self;
}
- (void)dealloc {
    [_data release];
    _data = nil;
    [_xmlFile release];
    _xmlFile = nil;
    [_thumbImage release];
    _thumbImage = nil;
    [_docPath release];
    _docPath = nil;

    [super dealloc];
}

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [CompanyDatabase nextScaryBugDocPathCompany];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

- (CompanyObj *)data {
    
    if (_data != nil) return _data;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[[NSData alloc] initWithContentsOfFile:dataPath] autorelease];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [[unarchiver decodeObjectForKey:kDataKey] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    return _data;
    
}

- (void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [archiver release];
    [data release];
    
}

- (UIImage *)thumbImage {
    
    if (_thumbImage != nil) return _thumbImage;
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
    
}

- (NSData *)xmlFile {
    if (_xmlFile != nil) return _xmlFile;
    return nil;
}

- (void)saveImages {
    
    //if (_thumbImage == nil || _fullImage == nil) return;
    
    [self createDataPath];
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    [_xmlFile writeToFile:fullImagePath atomically:YES];
    
    self.thumbImage = nil;
    self.xmlFile = nil;
    
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}
@end

