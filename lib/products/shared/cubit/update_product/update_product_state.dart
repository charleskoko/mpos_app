part of 'update_product_cubit.dart';

@immutable
abstract class UpdateProductState {}

class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductUpdated extends UpdateProductState {
  final Product product;
  UpdateProductUpdated(this.product);
}

class UpdateProductError extends UpdateProductState {
  final String message;
  UpdateProductError(this.message);
}
