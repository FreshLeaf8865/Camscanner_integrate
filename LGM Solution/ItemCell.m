//
//  ItemCell.m
//  LGM Solution
//
//  Created by Phan Minh Tam on 5/6/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import "ItemCell.h"
#import "ItemObj.h"
#import "Define.h"

@implementation ItemCell

- (void)awakeFromNib {
    // Initialization code
    float xOfLabel = 0.0;
    for (UIView *subview in self.contentView.subviews) {
        if (![subview isKindOfClass:[UIButton class]] && ![subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    for (NSString *s in _arrText) {
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(xOfLabel, 0, (self.contentView.frame.size.width-_arrText.count-45)/(_arrText.count), heightOfTextField)];
        UIFont *font = lb1.font;
        NSRange range = [s rangeOfString:@"> : "];
        NSString *substring = [[s substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [lb1 setText:substring];
        lb1.textAlignment = NSTextAlignmentCenter;
        UIFont *f1 = lb1.font;
        UIFontDescriptor * fD1 = [font.fontDescriptor
                                  fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        f1 = [UIFont fontWithDescriptor:fD1 size:11];
        [lb1 setFont:f1];
        [lb1 setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:lb1];
        xOfLabel += (self.contentView.frame.size.width-_arrText.count-45)/(_arrText.count);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
