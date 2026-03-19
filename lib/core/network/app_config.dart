class AppConfig {
  // Android emulator uses 10.0.2.2 to reach host machine.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5200',
  );
}
