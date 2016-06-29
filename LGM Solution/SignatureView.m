//
//  CameraView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "SignatureView.h"
#import "Define.h"

@implementation SignatureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect)rect label:(NSString*)label alt:(NSString *)alt{
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
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft, lb.frame.origin.y+lb.frame.size.height+alignTop/2, 90, heightOfTextField)];
        [bt setTitle:@"Signature" forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"bt_reset.png"] forState:UIControlStateNormal];
        [bt addTarget:self  action:@selector(mySignature) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(bt.frame.size.width+alignLeft+20, bt.frame.origin.y-alignTop/2, 180, 120)];
        image.image = [UIImage imageNamed:@"default.png"];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:image];
        
        UILabel *lbAlt = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, image.frame.origin.y+image.frame.size.height-10, widthOfTextField, heightOfTextField*2)];
        [lbAlt setText:[alt uppercaseString]];
        [lbAlt setNumberOfLines:0];
        [lbAlt setTextColor:colorLabel];
        UIFont *font1 = lbAlt.font;
        font1 = [UIFont fontWithName:font1.fontName size:14];
        [lbAlt setFont:font1];
        lbAlt.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbAlt];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, lbAlt.frame.origin.y+lbAlt.frame.size.height-8, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)mySignature{
    [self.superview endEditing:YES];
    GetSignature *popup = [[[NSBundle mainBundle] loadNibNamed:@"GetSignature" owner:self options:nil] objectAtIndex:0];
    popup.delegate = self;
    [popup showInView:self.superview];
}
-(void)clickOKSignature:(UIImage *)img{
    [image setImage:img];
    [_delegate getSignature:img view:self];
}
@end
