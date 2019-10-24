import 'package:flutter_bloc_lyrics/feature/song/bloc/songs_search_bloc.dart';
import 'package:flutter_bloc_lyrics/feature/song/bloc/songs_search_event.dart';
import 'package:flutter_bloc_lyrics/feature/song/bloc/songs_search_state.dart';
import 'package:flutter_bloc_lyrics/model/song_base.dart';
import 'package:flutter_bloc_lyrics/repository/lyrics_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLyricsRepository extends Mock implements LyricsRepository {}

class MockSongBase extends Mock implements SongBase {}

void main() {
  SongsSearchBloc songsSearchBloc;
  MockLyricsRepository lyricsRepository;

  setUp(() {
    lyricsRepository = MockLyricsRepository();
    songsSearchBloc = SongsSearchBloc(lyricsRepository: lyricsRepository);
  });

  tearDown(() {
    songsSearchBloc?.close();
  });

  test('after initialization bloc state is correct', () {
    expect(SearchStateEmpty(), songsSearchBloc.initialState);
  });

  test('after closing bloc does not emit any states', () {
    expectLater(songsSearchBloc, emitsInOrder([SearchStateEmpty(), emitsDone]));

    songsSearchBloc.close();
  });

  test('emits success state after insering lyrics search query', () {
    String query = "query.test";
    List<SongBase> songsList = List();
    songsList.add(MockSongBase());

    final expectedResponse = [
      SearchStateEmpty(),
      SearchStateLoading(),
      SearchStateSuccess(songsList, query)
    ];

    when(lyricsRepository.searchSongs(query))
        .thenAnswer((_) => Future.value(songsList));

    expectLater(songsSearchBloc, emitsInOrder(expectedResponse));

    songsSearchBloc.add(TextChanged(query: query));
  });
}
