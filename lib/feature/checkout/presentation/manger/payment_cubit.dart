import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_app/feature/checkout/data/repo/checkout_repo.dart';
import 'package:payment_app/feature/checkout/presentation/manger/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.checkoutRepo) : super(PaymentInitial());
  final CheckoutRepo checkoutRepo;

  Future<void> makePayment(paymentIntent) async {
    emit(PaymentLoading());
    final result = await checkoutRepo.makePayment(paymentIntent);
    result.fold(
      (failure) => emit(PaymentFailure(failure.errorMessage)),
      (sucess) => emit(PaymentSuccess()),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
