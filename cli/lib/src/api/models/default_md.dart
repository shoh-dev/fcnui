class DefaultResponse<T, E> {
  final bool success;
  final T? data;
  final E? error;

  const DefaultResponse({required this.success, this.data, this.error});

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

abstract class DefaultError {
  final String? message;
  const DefaultError({this.message});
}

class DefaultErrorImpl extends DefaultError {
  const DefaultErrorImpl({super.message});
}

abstract class DefaultData {
  const DefaultData();
}
