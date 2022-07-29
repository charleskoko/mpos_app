part of 'store_product_cubit.dart';

@immutable
abstract class StoreProductState {}

class StoreProductInitial extends StoreProductState {}

class StoreProductLoading extends StoreProductState {}

class StoreProductStored extends StoreProductState {
  final Product product;
  StoreProductStored(this.product);
}

class StoreProductError extends StoreProductState {
  final String? message;
  StoreProductError(this.message);
}
