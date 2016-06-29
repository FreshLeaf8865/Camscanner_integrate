//
//  Textfield.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/5/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextfieldDelegate.h"

@interface Textfield : UIView<UITextFieldDelegate>{
    NSString *val, *isEmp;
}

-(id)initWithRect:(CGRect)rect label:(NSString*)label validate:(NSString*)validate isEmpty:(NSString*)isEmpty alt:(NSString*)alt;
@property (nonatomic, retain) id<TextfieldDelegate> delegate;
@property (nonatomic, retain) UITextField *tf;
@end
