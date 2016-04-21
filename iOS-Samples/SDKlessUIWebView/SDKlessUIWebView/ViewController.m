#import "AppData.h"
#import "ViewController.h"
@import WebKit;

@implementation ViewController {
    UIWebView *webView;
    NSArray *_keywords; // 外部ブラウザ起動用キーワードを保持する
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
    
    // HTML側から呼ばれるネイティブ処理。ネイティブ側でIDFA、LAT、バンドルIDを取得し、HTML側に戻す。
    // また、HTML側で設定してある外部ブラウザ起動用キーワードもここで受け取っている。
    if ([[url scheme] isEqualToString:@"gnjsscheme"]) {
        if ([[url resourceSpecifier] hasPrefix:@"call_native"]) {
            _keywords = @[];
            NSArray *tmp = [[url resourceSpecifier] componentsSeparatedByString:@"?"];
            if ([tmp count] > 1) {
                _keywords = [NSArray arrayWithArray:[tmp[1] componentsSeparatedByString:@","]];
            }
            NSString *js = [NSString stringWithFormat:@"gnjs_setParameters(%@, '%@', '%@');", ![AppData canTracking] ? @(true) : @(false), [AppData idfa], [AppData bundleId]];
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
        return NO;
    }

    // 広告がタップされた際の処理
    // HTML側で指定した外部キーワードが含まれていたら外部ブラウザで開くよう処理
    for (NSString *keyword in _keywords) {
        if ([urlString rangeOfString:keyword].location != NSNotFound) {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }

    return YES;
}

@end
