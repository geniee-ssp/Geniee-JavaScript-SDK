package jp.co.geniee.sample.ad.js;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // 定義したWebViewを取得
        final WebView webView = (WebView) findViewById(R.id.webview);

        // JavaScriptからネイティブの処理を呼び出せるように設定します。
        // 端末の広告IDやLAT、アプリのパッケージネームをJavaScript内の処理で利用します。
        WebSettings settings = webView.getSettings();
        settings.setLoadWithOverviewMode(true);
        settings.setBuiltInZoomControls(false);
        settings.setSupportZoom(false);
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            settings.setMediaPlaybackRequiresUserGesture(false);
        }
        Context context = getApplicationContext();
        webView.addJavascriptInterface(new AppData(context), "appData");


        // 広告をクリックした際に外部ブラウザでページ開くように設定します。
        // 広告はiFrame内に表示されるケースがあります。
        // この対応を行わないとiFrame内に広告クリック先のページが表示されます。
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                view.getContext().startActivity(intent);
                return true;
            };

            @TargetApi(Build.VERSION_CODES.N)
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Intent intent = new Intent(Intent.ACTION_VIEW, request.getUrl());
                view.getContext().startActivity(intent);
                return true;
            }
        });

        // このサンプルではローカルのHTMLファイル読み込んでいます。
        webView.loadUrl("file:///android_asset/sample.html");
    }

}
