part of 'delete_product_cubit.dart';

@immutable
abstract class DeleteProductState {}

class DeleteProductInitial extends DeleteProductState {}

class DeleteProductDeleted extends DeleteProductState {}

class DeleteProductError extends DeleteProductState {
  final String? errorMessage;
  DeleteProductError(this.errorMessage);
}

class DeleteProductLoading extends DeleteProductState {}
