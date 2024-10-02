/// Network status listener
abstract class NetworkStatusListener {
  // 获取当前网络状态
  Future<NetworkStatus> getNetworkStatus();

  // 监听网络状态
  void onChange(void Function(NetworkStatus networkStatus) callback);
}

class NetworkStatus {
  /// 网络是否已连接
  final bool connected;

  /// 网络类型
  final String networkType;

  NetworkStatus(this.connected, this.networkType);
}
