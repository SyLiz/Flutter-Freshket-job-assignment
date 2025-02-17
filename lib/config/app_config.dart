enum AppEnvironment { development, staging, production }

class AppConfig {
  // Static field for config
  static late final EnvironmentConfig config;

  // Static method to initialize the static config field
  AppConfig._(); // Private constructor

  // Static method to set the config
  static void initialize(EnvironmentConfig environmentConfig) {
    config = environmentConfig;
  }

  static String get baseURL => config.baseURL;
}

class EnvironmentConfig {
  final AppEnvironment env;
  final String baseURL;
  EnvironmentConfig({required this.env, required this.baseURL});

  static final development = EnvironmentConfig(env: AppEnvironment.development, baseURL: 'http://10.0.2.2:8080/');
  static final staging = EnvironmentConfig(env: AppEnvironment.staging, baseURL: 'http://10.0.2.2:8080/');
  static final production = EnvironmentConfig(env: AppEnvironment.production, baseURL: 'http://10.0.2.2:8080/');
}
