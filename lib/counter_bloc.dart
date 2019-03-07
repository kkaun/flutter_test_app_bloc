import 'dart:async';

import 'counter_event.dart';


class CounterBloc {

  int _counter = 0;

  //You can think of StreamController as of a box which has two holes
  //- one for the INPUT and the other for the OUTPUT.
  final _counterStateController = StreamController<int>();

  //One for the INPUT is called a sink:
  StreamSink<int> get _inCounter => _counterStateController.sink;

  //Other for the OUTPUT is called a stream:
  //For state, exposing only a stream which outputs data
  Stream<int> get outCounter => _counterStateController.stream;



  final _counterEventController = StreamController<CounterEvent>();
  //For events, exposing ONLY a sink which is an INPUT
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;


  CounterBloc() {
    //Whenever there is a new event, we want to map it to the new state
    _counterEventController.stream.listen(_mapEventToState);
  }


  void _mapEventToState(CounterEvent event) {
    if(event is IncrementEvent) _counter++;
    else _counter--;

    _inCounter.add(_counter);
  }


  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
}

