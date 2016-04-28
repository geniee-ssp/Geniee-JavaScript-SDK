#import "AppData.h"
#import "ViewController.h"
@import WebKit;

@implementation ViewController {
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];

    // このサンプルアプリでのレイアウト調整を行っています。
    webView.scrollView.bounces = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.delegate = self;
    id topGuide = self.topLayoutGuide;
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView, topGuide)]];

    // ページの読み込み
    // このサンプルアプリではローカルのtest.htmlを読み込んでいます。
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)_webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {

    NSURL *url = [request URL];
    NSString *urlString = [[request URL] absoluteString];
    
    // HTML側から呼ばれるネイティブ処理。ネイティブ側でIDFA、LAT、バンドルID、キャリアを取得し、HTML側に戻す。
    if ([[url scheme] isEqualToString:@"gnjsscheme"]) {
        if ([[url resourceSpecifier] hasPrefix:@"call_native"]) {
            NSString *js = [NSString stringWithFormat:@"gnjs_setParameters(%@, '%@', '%@', '%@');", ![AppData canTracking] ? @(true) : @(false), [AppData idfa], [AppData bundleId], [AppData carrierCode]];
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
        return NO;
    }

    // URLに外部ブラウザで起動するためのキーワードが含まれていたら外部ブラウザで開く処理
    // (広告に管理画面で設定したキーワードが設定され、広告をタップすると外部ブラウザで開く処理を実現する)
    // 下の例の、@"外部ブラウザ起動用キーワード"を登録済みのものに書き換える。
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([urlString rangeOfString:@"外部ブラウザ起動用キーワード"].location != NSNotFound) {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }

    return YES;
}

@end
