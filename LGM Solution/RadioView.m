//
//  RadioView.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/8/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "RadioView.h"
#import "Define.h"
#import "RadioObj.h"

@implementation RadioView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect)rect label:(NSString*)label radio:(NSMutableArray *)radio{
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
        
        RadioObj *obj1 = [radio objectAtIndex:0];
        RadioObj *obj2 = [radio objectAtIndex:1];
        
        btYes = [[UIButton alloc] initWithFrame:CGRectMake(alignLeft*5, lb.frame.origin.y+lb.frame.size.height, 90, heightOfTextField)];
        [btYes setTitle:obj1.label forState:UIControlStateNormal];
        [btYes setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btYes];
        
        btNo = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - alignLeft*5- btYes.frame.size.width, lb.frame.origin.y+lb.frame.size.height, 90, heightOfTextField)];
        [btNo setTitle:obj2.label forState:UIControlStateNormal];
        [btNo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btNo];
        
        if (obj2.onChosen.length > 0) {
            [btNo setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
            [btYes setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
            [btNo addTarget:self  action:@selector(myNo2) forControlEvents:UIControlEventTouchUpInside];
            [btYes addTarget:self  action:@selector(myYes1) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btYes setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
            [btNo setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
            [btYes addTarget:self  action:@selector(myYes) forControlEvents:UIControlEventTouchUpInside];
            [btNo addTarget:self  action:@selector(myNo) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2*alignLeft, btNo.frame.origin.y+btNo.frame.size.height + alignBottom*2, rect.size.width-4*alignLeft, 1.5)];
        [line setBackgroundColor:[UIColor blueColor]];
        [line setAlpha:0.5];
        [self addSubview:line];
    }
    return  self;
}
-(void)myYes{
    [btYes setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [btNo setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_delegate clickYes:self];
}
-(void)myNo{
    [btNo setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [btYes setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_delegate clickNo:self];
}
-(void)myYes1{
    [btYes setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [btNo setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_delegate clickNo:self];
}
-(void)myNo2{
    [btNo setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    [btYes setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [_delegate clickYes:self];
}
@end
