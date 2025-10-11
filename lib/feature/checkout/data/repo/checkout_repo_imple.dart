import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/errors/failure.dart';
import 'package:payment_app/core/stripe_services.dart';
import 'package:payment_app/feature/checkout/data/repo/checkout_repo.dart';

import '../model/payment_intent_input_model.dart';

class CheckoutRepoImple extends CheckoutRepo {
  final StripeServices _stripeServices = StripeServices();
  @override
  Future<Either<Failure, void>> makePayment(
    PaymentIntentInputModel paymentIntent,
  ) async {
    try {
      await _stripeServices.makePayment(paymentIntent);
      return const Right(null);
    } on StripeException catch (e) {
      return Left(ServerFailure(e.error.message ?? ''));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? ''));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
