//
//  CSPdfPreviewViewController.m
//  TestCamScannerOpenAPI
//
//  Created by Felix on 15/3/2.
//  Copyright (c) 2015年 Nero. All rights reserved.
//

#import "CSPdfPreviewViewController.h"

@interface CSPdfPreviewViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) NSString *filePath;

@end

@implementation CSPdfPreviewViewController

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        self.filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    
    NSURL * htmlURL = [NSURL fileURLWithPath:self.filePath];
    
    if ([[self.filePath pathExtension] isEqualToString:@"html"])
    {
        htmlURL = [NSURL URLWithString:self.filePath];
    }
    
    
    //    NSURL * htmlURL = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest * request = [NSURLRequest requestWithURL:htmlURL];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 44);
    self.webView.scalesPageToFit = YES;
    //self.webView.delegate = self;
    [ self.webView sizeToFit];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:request];
}

- (void)done:(id)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
