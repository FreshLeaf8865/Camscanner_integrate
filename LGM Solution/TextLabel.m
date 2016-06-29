//
//  TextLabel.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/7/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "TextLabel.h"
#import "Define.h"

@implementation TextLabel

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
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(alignLeft, 0, rect.size.width-4*alignLeft, heightOfTextField)];
        [lb setText:label];
        
        UIFont *font = lb.font;
        UIFontDescriptor * fontD = [font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        font = [UIFont fontWithDescriptor:fontD size:15];
        [lb setFont:font];
        [lb setTextColor:colorLabel];
        [self addSubview:lb];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, lb.frame.origin.y+lb.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
@end
