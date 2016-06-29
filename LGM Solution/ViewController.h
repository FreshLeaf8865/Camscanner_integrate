//
//  ViewController.h
//  LGM Solution
//
//  Created by Phan Minh Tam on 4/23/15.
//  Copyright (c) 2015 Phan Minh Tam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    __weak IBOutlet UITableView *tbView;
    __weak IBOutlet UILabel *lbHello;
    NSTimer *timer, *timerLoadFile;
    int count;
    __weak IBOutlet HomeCell *homeCell;
    NSMutableArray *arrImage;
    NSString *company_ID;
    int countTotal;

}
@property (nonatomic, retain) NSMutableArray *arrData;
- (IBAction)clickRefresh:(id)sender;

- (IBAction)clickSignout:(id)sender;
@end

