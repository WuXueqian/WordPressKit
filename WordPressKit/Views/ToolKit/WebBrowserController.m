//
//  WebBrowserController.m
//  WordPressKit
//
//  Created by wuxueqian on 15/9/20.
//  Copyright (c) 2015年 wuxueqian. All rights reserved.
//

#import "WebBrowserController.h"

@interface WebBrowserController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *leftTopBtn;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIButton *rightTopBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomToolBar;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *goForwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
- (IBAction)closePage:(UIButton *)sender;
- (IBAction)moreFunc:(UIButton *)sender;
- (IBAction)goBack:(UIButton *)sender;
- (IBAction)goForward:(UIButton *)sender;
- (IBAction)stopOrRefresh:(UIButton *)sender;


@end

@implementation WebBrowserController{
    BOOL _pageLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageLoaded = NO;
    
    //Webview delegate
    self.webView.delegate = self;
    
    //加载url
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    //底部工具条上阴影
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomToolBar.bounds];
    self.bottomToolBar.layer.masksToBounds = NO;
    self.bottomToolBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomToolBar.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.bottomToolBar.layer.shadowOpacity = 0.2f;
    self.bottomToolBar.layer.shadowPath = shadowPath.CGPath;
    
    //工具条view前置 z-index
    [self.view bringSubviewToFront:self.bottomToolBar];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *theTitle=[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = theTitle;
    //是否显示后退前进按钮
    if ([self.webView canGoBack]) {
        self.goBackBtn.alpha = 1.0f;
        self.goBackBtn.enabled = YES;
    }else{
        self.goBackBtn.alpha = 0.3f;
        self.goBackBtn.enabled = NO;
    }
    if ([self.webView canGoForward]) {
        self.goForwardBtn.alpha = 1.0f;
        self.goForwardBtn.enabled = YES;
    }else{
        self.goForwardBtn.alpha = 0.3f;
        self.goForwardBtn.enabled = NO;
    }
    
    //判断document ready
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    if ([readyState isEqualToString:@"complete"]) {
        _pageLoaded = YES;
        [self.stopBtn setImage:[UIImage imageNamed:@"button_refresh_gray"] forState:UIControlStateNormal];
    }
}

//接收js通知
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [@"#" rangeOfString:[request.URL.absoluteString stringByReplacingOccurrencesOfString:self.webView.request.mainDocumentURL.absoluteString withString:@""]].location != 0) {
        _pageLoaded = NO;
        [self.stopBtn setImage:[UIImage imageNamed:@"barbutton_stop_gray"] forState:UIControlStateNormal];
        [self.webView loadRequest:request];
    }
    return YES;
}

#pragma mark - 按钮动作IBAction
- (IBAction)closePage:(UIButton *)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)moreFunc:(UIButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"破坏性按钮" otherButtonTitles:@"分享到微博", @"分享到朋友圈", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)goBack:(UIButton *)sender{
    _pageLoaded = NO;
    [self.stopBtn setImage:[UIImage imageNamed:@"barbutton_stop_gray"] forState:UIControlStateNormal];
    [self.webView goBack];
}

- (IBAction)goForward:(UIButton *)sender{
    _pageLoaded = NO;
    [self.stopBtn setImage:[UIImage imageNamed:@"barbutton_stop_gray"] forState:UIControlStateNormal];
    [self.webView goForward];
}

- (IBAction)stopOrRefresh:(UIButton *)sender{
    if (_pageLoaded) {
        [self.webView reload];
    }else{
        [self.webView stopLoading];
    }
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
