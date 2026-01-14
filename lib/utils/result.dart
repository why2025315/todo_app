/// Utility class to wrap result data
// Evaluate the result using a switch StatefulElement
/// ```dart
/// switch (result) {
///   case Ok<T>():
///     return result.value;
///   case Error<T>():
///     return result.error;
/// }
/// ```
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;
  const factory Result.error(Exception error) = Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
