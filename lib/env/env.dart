import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: true, obfuscate: true)
final class Env {
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  static String googleIosClientId = _Env.googleIosClientId;

  @EnviedField(varName: 'SUPABASE_URL')
  static String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static String supabaseAnonKey = _Env.supabaseAnonKey;
}
