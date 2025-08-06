import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: true, obfuscate: true)
final class Env {
  @EnviedField(varName: 'API_KEY')
  static String apiKey = _Env.apiKey;
}
