import 'package:equatable/equatable.dart';

class DefaultResponse<T, E> extends Equatable {
  final bool success;
  final T? data;
  final E? error;

  const DefaultResponse({required this.success, this.data, this.error});

  @override
  List<Object?> get props => [success, data, error];

  @override
  bool? get stringify => true;

  //copyWith method
  DefaultResponse<T, E> copyWith({
    bool? success,
    T? data,
    E? error,
  }) {
    return DefaultResponse<T, E>(
      success: success ?? this.success,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

abstract class DefaultError extends Equatable {
  final String? message;
  const DefaultError({this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

class DefaultErrorImpl extends DefaultError {
  const DefaultErrorImpl({super.message});
}

abstract class DefaultData extends Equatable {
  const DefaultData();
}
