#import "AppData.h"
#import "ViewController.h"
@import WebKit;

@interface ViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation ViewController {
    WKWebView *webView;
    NSArray *keywords;
}

- (WKWebViewConfiguration *)createConfiguration {

    // ネイティブでIDFAやLAT、バンドルIDを取得し、HTML側に渡す処理
    NSString *setParams =
        [NSString stringWithFormat:@"var geparams = window.geparams || {}; "
                                   @"geparams.lat = %@; geparams.idfa = '%@'; geparams.bundle = '%@';",
                                   ![AppData canTracking] ? @(true) : @(false), [AppData idfa], [AppData bundleId]];
    WKUserScript *userScriptSetParams = [[WKUserScript alloc]
          initWithSource:setParams
           injectionTime:WKUserScriptInjectionTimeAtDocumentStart
        forMainFrameOnly:YES];

    // HTML側で指定している外部ブラウザ起動用キーワード(clickkeywords)をネイティブ側から取得する処理
    NSString *getKeywords =
        [NSString stringWithFormat:@"window.webkit.messageHandlers.bridgeKeywords.postMessage(clickkeywords);"];
    WKUserScript *userScriptKeywords = [[WKUserScript alloc]
          initWithSource:getKeywords
           injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
        forMainFrameOnly:YES];

    WKUserContentController *userContentController =
        [[WKUserContentController alloc] init];
    [userContentController addUserScript:userScriptSetParams];
    [userContentController addUserScript:userScriptKeywords];
    [userContentController addScriptMessageHandler:self name:@"bridgeKeywords"];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    return configuration;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [self createConfiguration];
    webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                 configuration:configuration];

    [self.view addSubview:webView];

    // このサンプルアプリでのレイアウト調整を行っています。
    webView.scrollView.bounces = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.navigationDelegate = self;
    id topGuide = self.topLayoutGuide;
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:
                   [NSLayoutConstraint
                       constraintsWithVisualFormat:@"H:|[webView]|"
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(
                                                       webView)]];
    [self.view addConstraints:
                   [NSLayoutConstraint
                       constraintsWithVisualFormat:@"V:[topGuide]-[webView]|"
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(
                                                       webView, topGuide)]];

    // ページの読み込み
    // このサンプルアプリではローカルのtest.htmlを読み込んでいます。
    NSURL *url =
        [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

// HTML側で指定している外部ブラウザ起動用キーワード(clickkeywords)をネイティブ側で取得する処理
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"bridgeKeywords"]) {
        if ([message.body isKindOfClass:[NSArray class]]) {
            keywords = [NSArray arrayWithArray:message.body];
        }
    }
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:
                        (void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = [url absoluteString];

    // 広告がタップされた際の処理
    // HTML側で指定した外部キーワードが含まれていたら外部ブラウザで開くよう処理
    for (NSString *keyword in keywords) {
        if ([urlString rangeOfString:keyword].location != NSNotFound) {
            [[UIApplication sharedApplication] openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
