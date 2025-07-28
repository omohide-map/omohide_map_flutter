import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: true)
final class Env {
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  static const String googleIosClientId = _Env.googleIosClientId;

  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}
