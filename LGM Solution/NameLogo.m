//
//  NameLogo.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/27/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "NameLogo.h"
#import "Define.h"

@implementation NameLogo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
-(id)initWithLogo:(UIImage*)image title:(NSString*)title rect:(CGRect)rect{
    if (self = [super initWithFrame:rect]){
        [self setFrame:rect];
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.height*2, rect.size.height)];
        
        if (image != nil) {
            [imgLogo setImage:image];
        }else{
            [imgLogo setImage:[UIImage imageNamed:@"default.png"]];
        }
        [imgLogo setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imgLogo];
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(imgLogo.frame.size.width+10, 0, rect.size.width-imgLogo.frame.size.width-10, rect.size.height)];
        [lbTitle setTextColor:[UIColor redColor]];
        UIFont *font = lbTitle.font;
        [lbTitle setFont:[UIFont fontWithName:font.fontName size:16]];
        lbTitle.numberOfLines = 0;
        [lbTitle setText:title];
        [self addSubview:lbTitle];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(alignLeft, rect.size.height-2, rect.size.width-2*alignLeft, 2)];
//        [line setBackgroundColor:[UIColor blueColor]];
//        [self addSubview:line];
    }
    return  self;
}

@end
