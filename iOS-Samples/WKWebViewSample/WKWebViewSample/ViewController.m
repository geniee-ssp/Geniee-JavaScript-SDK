#import "AppData.h"
#import "ViewController.h"
@import WebKit;

@interface ViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation ViewController {
    WKWebView *webView;
}

- (WKWebViewConfiguration *)createConfiguration {

    // ネイティブでIDFAやLAT、バンドルIDを取得し、HTML側に渡す処理
    NSString *setParams =
        [NSString stringWithFormat:@"var geparams = window.geparams || {}; "
                                   @"geparams.lat = %@; geparams.idfa = '%@'; geparams.bundle = '%@';",
                                   ![AppData canTracking] ? @(true) : @(false), [AppData idfa], [AppData bundleId]];
    
    WKUserScript *userScriptSetParams = [[WKUserScript alloc] initWithSource:setParams
                                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                            forMainFrameOnly:YES];

    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:userScriptSetParams];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    return configuration;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [self createConfiguration];
    webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];

    [self.view addSubview:webView];

    // このサンプルアプリでのレイアウト調整を行っています。
    webView.scrollView.bounces = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.navigationDelegate = self;
    id topGuide = self.topLayoutGuide;
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(webView, topGuide)]];

    // ページの読み込み
    // このサンプルアプリではローカルのtest.htmlを読み込んでいます。
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = [url absoluteString];

    // URLに外部ブラウザで起動するためのキーワードが含まれていたら外部ブラウザで開く処理
    // (広告に管理画面で設定したキーワードが設定され、広告をタップすると外部ブラウザで開く処理を実現する)
    if ([urlString rangeOfString:@"外部ブラウザ起動用キーワード"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
