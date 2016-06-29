//
//  QrCodeView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/11/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "QrCodeView.h"
#import "Define.h"

@implementation QrCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect)rect label:(NSString*)label{
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
    
        tf = [[UITextField alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.size.height+5, widthOfTextField-80, heightOfTextField)];
        [tf setBorderStyle:UITextBorderStyleRoundedRect];
        tf.delegate = self;
        [self addSubview:tf];
        
        UIButton *btYes = [[UIButton alloc] initWithFrame:CGRectMake(tf.frame.origin.y+tf.frame.size.width, tf.frame.origin.y, 60, heightOfTextField)];
        [btYes setTitle:@"Scan" forState:UIControlStateNormal];
        [btYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btYes setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
        [btYes addTarget:self  action:@selector(clickQrcode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btYes];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, btYes.frame.origin.y+btYes.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)clickQrcode{
    [self.superview endEditing:YES];
    ScaningView *popup = [[[NSBundle mainBundle] loadNibNamed:@"ScaningView" owner:self options:nil] objectAtIndex:0];
    popup.delegate = self;
    [popup showInView:self.superview];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_delegate getTextScan:textField.text view:self];
}

-(void)resultScan:(NSString *)text{
    tf.text = text;
    [_delegate getTextScan:text view:self];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
