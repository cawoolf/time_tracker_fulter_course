import 'dart:async';

class SignInBloc {
  final StreamController<bool> _isLoadingController =
      StreamController<bool>(); // private
  Stream<bool> get isLoadingStream =>
      _isLoadingController.stream; // Public getter Accessed by the SignInPage

  void dispose() {
    _isLoadingController.close();
  }

  // adds the isLoading var to the Sink of the Controller
  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
}
