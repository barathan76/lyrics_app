import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/lyrics.dart';
import '../resources/repository.dart';

class MusicDetailBloc {
  final _repository = Repository();
  final _trackId = PublishSubject<int>();
  final _lyrics = BehaviorSubject<Future<lyrics>>();

  Function(int) get fetchTrailersById => _trackId.sink.add;
  Stream<Future<lyrics>> get movieTrailers => _lyrics.stream;

  MusicDetailBloc() {
    _trackId.stream.transform(_itemTransformer()).pipe(_lyrics);
  }

  dispose() async {
    _trackId.close();
    await _lyrics.drain();
    _lyrics.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer((Future<lyrics> trailer, int id, int index) {
      trailer = _repository.fetchLyrics(id);
      return trailer;
    }, emptyFutureTrailerModel());
  }

  Future<lyrics> emptyFutureTrailerModel() async {
    return lyrics();
  }
}
