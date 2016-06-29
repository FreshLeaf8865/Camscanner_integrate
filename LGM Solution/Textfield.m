//
//  Textfield.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/5/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "Textfield.h"
#import "Define.h"

@implementation Textfield

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(id)initWithRect:(CGRect)rect label:(NSString*)label validate:(NSString*)validate isEmpty:(NSString*)isEmpty alt:(NSString *)alt{
    if (self = [super initWithFrame:rect]){
        [self setFrame:rect];
        [self setBackgroundColor:[UIColor whiteColor]];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, 0, rect.size.width-2*alignLeft, heightOfTextField)];
        [lb setText:label];
        
        UIFont *font = lb.font;
        UIFontDescriptor * fontD = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        font = [UIFont fontWithDescriptor:fontD size:15];
        [lb setFont:font];
        [lb setTextColor:colorLabel];
        [self addSubview:lb];
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.size.height+5, widthOfTextField, heightOfTextField)];
        [_tf setBorderStyle:UITextBorderStyleRoundedRect];
        if ([[validate lowercaseString] isEqualToString:@"integer"]) {
            [_tf setKeyboardType:UIKeyboardTypeNumberPad];
        }else if ([[validate lowercaseString] isEqualToString:@"decimal"]){
            [_tf setKeyboardType:UIKeyboardTypeDecimalPad];
        }
        _tf.delegate = self;
        [self addSubview:_tf];
        
        if (alt.length > 0) {
            UILabel *lbAlt = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, _tf.frame.origin.y+_tf.frame.size.height, widthOfTextField, heightOfTextField)];
            [lbAlt setText:[alt uppercaseString]];
            [lbAlt setNumberOfLines:0];
            [lbAlt setTextColor:colorAlt];
            UIFont *font1 = lbAlt.font;
            font1 = [UIFont fontWithName:font1.fontName size:13];
            [lbAlt setFont:font1];
            lbAlt.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lbAlt];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, lbAlt.frame.origin.y+lbAlt.frame.size.height, rect.size.width-4*alignLeft, 1.5)];
            [line setBackgroundColor:[UIColor blueColor]];
            [line setAlpha:0.5];
            [self addSubview:line];
        }else{
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, _tf.frame.origin.y+_tf.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
            [line setBackgroundColor:[UIColor blueColor]];
            [line setAlpha:0.5];
            [self addSubview:line];
        }
        
        val = validate;
        isEmp = isEmpty;
    }
    return  self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_delegate getText:textField view:self];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([val isEqualToString:@"Decimal"]) {
        NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
        [characterSet addCharactersInString:@"-"];
        [characterSet addCharactersInString:@"."];
        
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }else{
            if (!string.length)
                return YES;
            if (textField.text.length == 0 && [string isEqualToString:@"."]) {
                return NO;
            }
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,9})?)?$";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                                options:0
                                                                  range:NSMakeRange(0, [newString length])];
            if (numberOfMatches == 0)
                return NO;
        }
    }
    
    return YES;
}
-(BOOL)CountDOT:(NSString*)input{
    if([[input componentsSeparatedByString:@"."] count] > 2) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification object:nil];
    return YES;
}
- (BOOL)isValidFloatString:(NSString *)str
{
    const char *s = str.UTF8String;
    char *end;
    strtod(s, &end);
    return !end[0];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
