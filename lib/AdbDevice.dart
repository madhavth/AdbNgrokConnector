class AdbDevice {
  String deviceName;
  String deviceIp;

  AdbDevice(this.deviceName, this.deviceIp);

  @override
  String toString() {
    return "$deviceName, $deviceIp";
  }

  @override
  int get hashCode => deviceName.hashCode ^ deviceIp.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AdbDevice)
      return deviceName == other.deviceName && deviceIp == other.deviceIp;

    return false;
  }
}
