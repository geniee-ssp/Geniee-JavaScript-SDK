#import "AppData.h"
#import "ViewController.h"
@import WebKit;

@interface ViewController () <WKNavigationDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlField;

@end

@implementation ViewController {
    WKWebView *wkwebView;
}

- (WKWebViewConfiguration *)createConfiguration {

    // ネイティブでIDFAやLAT、バンドルID、キャリアを取得し、HTML側に渡す処理
    NSString *setParams =
        [NSString stringWithFormat:@"var geparams = window.geparams || {}; "
                                   @"geparams.lat = %@; geparams.idfa = '%@'; geparams.bundle = '%@';",
                                   ![AppData canTracking] ? @(true) : @(false), [AppData idfa], [AppData bundleId]];
    if ([AppData carrierCode].length) {
        setParams = [setParams stringByAppendingFormat:@"geparams.carrier = '%@';", [AppData carrierCode]];
    }
    
    WKUserScript *userScriptSetParams = [[WKUserScript alloc] initWithSource:setParams
                                                               injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                            forMainFrameOnly:YES];

    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:userScriptSetParams];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    configuration.mediaTypesRequiringUserActionForPlayback = NO;
    configuration.allowsInlineMediaPlayback = YES;
    return configuration;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [self createConfiguration];
    wkwebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    [self.view addSubview:wkwebView];
    
    // このサンプルアプリでのレイアウト調整を行っています。
    wkwebView.scrollView.bounces = NO;
    wkwebView.scrollView.scrollEnabled = YES;
    wkwebView.navigationDelegate = self;
    [wkwebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wkwebView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(wkwebView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_urlField]-[wkwebView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(wkwebView, _urlField)]];

    

    // ページの読み込み
    // このサンプルアプリではローカルのtest.htmlを読み込んでいます。
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    //NSURL *url = [NSURL URLWithString:@"https://geniee.co.jp/"];

   [wkwebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@",self.urlField.text);
    
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    //NSURL *url = [NSURL URLWithString:@"https://geniee.co.jp/"];
    [wkwebView loadRequest:[NSURLRequest requestWithURL:url]];
    return YES;
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = [url absoluteString];

    // URLに外部ブラウザで起動するためのキーワードが含まれていたら外部ブラウザで開く処理
    // (広告に管理画面で設定したキーワードが設定され、広告をタップすると外部ブラウザで開く処理を実現する)
    // 下の例の、@"外部ブラウザ起動用キーワード"を登録済みのものに書き換える。
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if ([urlString rangeOfString:@"外部ブラウザ起動用キーワード"].location != NSNotFound) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
