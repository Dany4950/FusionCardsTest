import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:io';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  late WebViewController controller;
  bool isLoading = true;
  static const String PREF_MOKSA_TOKEN = 'moksa_auth_token';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PREF_MOKSA_TOKEN);

    debugPrint('Retrieved token: $token');

    final baseUrl = 'https://mobile.moksa.ai/';
    final url = token != null ? '$baseUrl?token=$token' : baseUrl;

    debugPrint('Loading URL: $url');

    // Create platform specific parameters with inline media playback enabled on iOS
    final params = Platform.isIOS 
      ? WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true)
      : const PlatformWebViewControllerCreationParams();
    controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            await _setCookies(token);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _setCookies(String? token) async {
    final cookieManager = WebViewCookieManager();

    if (token != null) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'auth_token',
          value: token,
          domain: 'moksa.ai',
        ),
      );
      debugPrint('🍪 Set auth_token cookie with value: $token'); // Debug log
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoksaNavBar('Live Screen'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
