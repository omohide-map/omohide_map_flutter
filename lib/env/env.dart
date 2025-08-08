import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: true, obfuscate: true)
final class Env {
  @EnviedField(varName: 'API_BASE_URL')
  static String apiBaseUrl = _Env.apiBaseUrl;
}
