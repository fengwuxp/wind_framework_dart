


### Network 检查
- [connectivity_plus](https://pub-web.flutter-io.cn/packages/connectivity_plus)
```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wind_http/src/network/network_status_listener.dart';

/// default  listener network status
class DefaultNetworkStatusListener implements NetworkStatusListener {
  final connectivity = Connectivity();

  @override
  Future<NetworkStatus> getNetworkStatus() {
    return connectivity.checkConnectivity().then((result) {
      bool connected = result.any((item) {
        return item == ConnectivityResult.none;
      });
      return NetworkStatus(connected, result.join(","));
    });
  }

  @override
  void onChange(callback) {
    connectivity.onConnectivityChanged.listen((result) {
      bool connected = result.any((item) {
        return item == ConnectivityResult.none;
      });
      callback(NetworkStatus(connected, result.join(",")));
    });
  }
}

```