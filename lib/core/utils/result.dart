sealed class Result<T, E extends Exception?> {
  const Result();
}

final class Success<T, E extends Exception> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

final class Failure<T, E extends Exception> extends Result<T, E> {
  final E exception;

  const Failure(this.exception);
}
