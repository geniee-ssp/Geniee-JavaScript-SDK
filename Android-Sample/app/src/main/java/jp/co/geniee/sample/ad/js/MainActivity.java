package jp.co.geniee.sample.ad.js;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

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
        webView.getSettings().setJavaScriptEnabled(true);
        Context context = getApplicationContext();
        webView.addJavascriptInterface(new AppData(context), "appData");

        // 広告をクリックした際に外部ブラウザでページ開くように設定します。
        // 広告はiFrame内に表示されるケースがあります。
        // この対応を行わないとiFrame内に広告クリック先のページが表示されます。
        webView.setWebViewClient(new WebViewClient() {

            @Override
            public void onLoadResource(WebView view, String url) {

                // URLにキーワードが含まれていたら 広告がクリックされたと判断
                if (url.contains("管理ツールで設定したキーワード")) {
                    // 外部ブラウザで開くのでWebView内での読み込みを中断します。
                    webView.stopLoading();

                    // 外部ブラウザで開きます。
                    Uri uri = Uri.parse(url);
                    Intent i = new Intent(Intent.ACTION_VIEW, uri);
                    startActivity(i);
                    return;
                }

                super.onLoadResource(view, url);
            }
        });

        // このサンプルではローカルのHTMLファイル読み込んでいます。
        webView.loadUrl("file:///android_asset/sample.html");
    }

}
