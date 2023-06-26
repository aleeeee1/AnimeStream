package it.animestream.baka

import com.zezo357.flutter_meedu_videoplayer.MeeduPlayerFlutterActivity
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.*

class MainActivity: MeeduPlayerFlutterActivity() {
   init {
       try {
           val trustAllCerts: Array<TrustManager> = arrayOf<TrustManager>(
               object : X509TrustManager {
                   val acceptedIssuers: Array<Any?>?
                       get() = arrayOfNulls(0) 

                   override fun checkClientTrusted(certs: Array<X509Certificate?>?, authType: String?) {}
                   override fun checkServerTrusted(certs: Array<X509Certificate?>?, authType: String?) {}
                   override fun getAcceptedIssuers(): Array<X509Certificate> {
                       TODO("Not yet implemented")
                   }
               }
           )
           val sc: SSLContext = SSLContext.getInstance("SSL")
           sc.init(null, trustAllCerts, SecureRandom())
           HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory())
           HttpsURLConnection.setDefaultHostnameVerifier(object : HostnameVerifier {
               override fun verify(arg0: String?, arg1: SSLSession?): Boolean {
                   return true
               }
           })
       } catch (e: Exception) {
       }
   }
}

