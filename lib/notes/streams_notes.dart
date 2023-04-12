import 'dart:async';

class StreamsNotes {
  void runStreamController() {
    final controller = StreamController();
    addNumToStream(controller, 1);
    addNumToStream(controller, 2);
    addErrorsToStream(controller, 6);
    addErrorsToStream(controller, 7);

    controller.close(); // Closes the Stream and prevents future events from being added.

    // listening using .stream.listen
    // prints to the console as the values are pushed to the stream.
    // Handles errors in the Stream
    controller.stream.listen((value) {
      print(value);
    }, onError: (error) {
      print(error);
    }, onDone: (){
      print('String closed. Done');
    }
    );
  }

  void addNumToStream(StreamController controller, value) {
    // adding using .sink
    controller.sink.add(value);
  }

  void addErrorsToStream(StreamController controller, int value) {
    if (value <= 5) {
      controller.sink.add(value);
    } else {
      controller.sink.add(StateError('$value is greater than 5'));
    }
  }
}

/*
Three types of Stream events:
Data, Error, and Done

Closing when you're done with the Stream is efficient. Releases resources.

Data can be of any possible type.StreamController
*/