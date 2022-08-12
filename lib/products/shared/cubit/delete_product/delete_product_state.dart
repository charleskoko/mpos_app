part of 'delete_product_cubit.dart';

@immutable
abstract class DeleteProductState {}

class DeleteProductInitial extends DeleteProductState {}

class DeleteProductDeleted extends DeleteProductState {}

class DeleteProductError extends DeleteProductState {
  final String? message;
  DeleteProductError(this.message);
}

class DeleteProductLoading extends DeleteProductState {}
