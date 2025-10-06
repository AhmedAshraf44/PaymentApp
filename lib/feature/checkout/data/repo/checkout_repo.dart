import 'package:dartz/dartz.dart';
import 'package:payment_app/core/errors/failure.dart';
import 'package:payment_app/feature/checkout/data/payment_intent_model/payment_intent_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(PaymentIntentModel paymentIntent);
}
