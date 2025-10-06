import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String publishableKey = _Env.publishableKey;

  @EnviedField(varName: 'SECRET_TOKEN', obfuscate: true)
  static final String secretKey = _Env.secretKey;
}
