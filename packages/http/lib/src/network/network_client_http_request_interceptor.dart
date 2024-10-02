import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/network/network_status_listener.dart';
import 'package:wind_http/src/network/none_network_fallback.dart';

/// It needs to be configured first in the [ClientHttpRequestInterceptor] list
///
/// Check whether the client network is available and can be degraded with custom processing.
/// For example, stack requests until the network is available or abandon the request
///
/// Network interception interceptor during the execution of http client, which conflicts with {@see NetworkFeignClientExecutorInterceptor}
class NetworkClientHttpRequestInterceptor implements ClientHttpRequestInterceptor {
  static const String _tag = "NetworkClientHttpRequestInterceptor";

  static final _log = Logger(_tag);

  final NetworkStatusListener networkStatusListener;

  final NoneNetworkFallBack networkFailBack;

  // Number of spin attempts to wait for network recovery
  final int tryWaitNetworkCount;

  // Maximum number of milliseconds for spin wait
  final int spinWaitMaxTimes;

  NetworkStatus _currentStatus = NetworkStatus(false, "unknown");

  NetworkClientHttpRequestInterceptor(this.networkStatusListener,
      {NoneNetworkFallBack? networkFailBack, int? tryWaitNetworkCount, int? spinWaitMaxTimes})
      : networkFailBack = networkFailBack ?? DefaultNoneNetworkFailBack(),
        tryWaitNetworkCount = tryWaitNetworkCount ?? 3,
        spinWaitMaxTimes = spinWaitMaxTimes ?? 500 {
    _initNetwork();

    // 注册网络监听
    networkStatusListener.onChange((newNetworkStatus) {
      if (!_currentStatus.connected && newNetworkStatus.connected) {
        // 网络被激活
        this.networkFailBack.onNetworkActive();
      }
      _currentStatus = newNetworkStatus;
    });
  }

  @override
  Future<ClientHttpResponse> intercept(ClientHttpRequest request, ClientHttpRequestExecution next) async {
    if (!_currentStatus.connected) {
      await _trySpinWait(request).then((value) => request).catchError((error, stackTrace) {
        _log.info("Waiting for network recovery error", error);
        networkFailBack.onNetworkClose(request);
        return Future.error(error, stackTrace);
      });
    }
    return next(request);
  }

  /// try spin wait network
  Future<void> _trySpinWait(ClientHttpRequest request) async {
    var tryWaitNetworkCount = this.tryWaitNetworkCount, spinWaitMaxTimes = this.spinWaitMaxTimes;
    if (tryWaitNetworkCount == 0) {
      return Future.error(request);
    }
    var random = Random();
    while (tryWaitNetworkCount-- > 0 && (!_currentStatus.connected)) {
      // 自旋等待网络恢复
      var times = random.nextInt(spinWaitMaxTimes);
      if (times < 120) {
        times = 120;
      }
      await _sleep(times);
      _initNetwork();
      return Future.value();
    }
  }

  void _initNetwork() {
    networkStatusListener.getNetworkStatus().then((networkStatus) {
      _currentStatus = networkStatus;
    }).catchError((error) {
      _log.info("get network status error", error);
    });
  }
}

Future<void> _sleep(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}
