import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String publishableKey = _Env.publishableKey;

  @EnviedField(varName: 'SECRET_TOKEN', obfuscate: true)
  static final String secretKey = _Env.secretKey;

  @EnviedField(varName: 'Client_ID_KEY', obfuscate: true)
  static final String clientKeyPaypal = _Env.clientKeyPaypal;

  @EnviedField(varName: 'SECRET_KEY_PAYPAL', obfuscate: true)
  static final String secretKeyPaypal = _Env.secretKeyPaypal;
}
