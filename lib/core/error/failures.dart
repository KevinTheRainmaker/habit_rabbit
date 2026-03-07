abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class SubscriptionFailure extends Failure {
  const SubscriptionFailure(super.message);
}

class HabitFailure extends Failure {
  const HabitFailure(super.message);
}
