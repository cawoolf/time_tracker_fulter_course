import 'dart:async';

class SignInBloc {
  final StreamController<bool> _isLoadingController =
      StreamController<bool>(); // Constructor with type <Type>, Only takes boolean values into the Stream? Correct

  Stream<bool> get isLoadingStream =>
      _isLoadingController.stream; // Public getter Accessed by the SignInPage

  void dispose() {
    _isLoadingController.close();
  }

  // adds the isLoading var to the Sink of the Controller
  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  // Only takes boolean values into the Stream. Other types give an error;
  // Can change the Stream type<> to dynamic or other types.
  // void testValues(int test) {
  //   _isLoadingController.add(true);
  //   _isLoadingController.add(test);
  //
  // }
}
