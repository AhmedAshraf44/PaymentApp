import 'package:dartz/dartz.dart';
import 'package:payment_app/core/errors/failure.dart';

import '../model/payment_intent_input_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
    PaymentIntentInputModel paymentIntent,
  );
}
