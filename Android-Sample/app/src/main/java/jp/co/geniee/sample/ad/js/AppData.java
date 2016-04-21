package jp.co.geniee.sample.ad.js;


import android.content.Context;
import android.webkit.JavascriptInterface;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

import java.io.IOException;


/**
 * アプリの各種情報を取得するクラスです。
 * JavaScriptから呼び出されるメソッドにはJavascriptInterfaceアノテーションが付与されています。
 *
 */
public class AppData {

    private Context context;

    public AppData(Context context) {
        this.context = context;
    }

    /**
     * @return 広告ID
     */
    @JavascriptInterface
    public String getAdvertisingId() {
        AdvertisingIdClient.Info info = getInfo();
        return info != null ? info.getId() : "";
    }

    /**
     * @return LAT (Limit Ad Tracking)
     */
    @JavascriptInterface
    public boolean getLat() {
        AdvertisingIdClient.Info info = getInfo();
        return info != null && info.isLimitAdTrackingEnabled();
    }

    /**
     * @return アプリのパッケージ名
     */
    @JavascriptInterface
    public String getPackageName() {
        return context.getPackageName();
    }

    /**
     * 広告IDやLATをAdvertisingIdClientから取得します。
     * AdvertisingIdClientを利用するにはGoogle Play services SDKが必要です。
     *
     * @return AdvertisingIdClientから取得した情報
     */
    private AdvertisingIdClient.Info getInfo(){
        try {
            return AdvertisingIdClient.getAdvertisingIdInfo(context);
        } catch (IOException |
                GooglePlayServicesNotAvailableException |
                GooglePlayServicesRepairableException e) {
            return null;
        }
    }

}
