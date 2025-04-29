import 'package:bloc/bloc.dart';
import 'package:dcristaldo/constants/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dio/dio.dart';
part 'events/news_event.dart';
part 'states/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
final Dio _dio = Dio();
  NewsBloc() : super(NewsInitial()) {
    on<NewsStarted>((event, emit) async {
      emit(NewsLoadInProgress());
      try {
        // Obtén la URL base desde el archivo .env
        final apiUrl = NewsConstants.noticiasEndpoint;

        final response = await _dio.get(apiUrl);

        // Verifica si la respuesta es exitosa
        if (response.statusCode == 200) {
          // Mapea los datos de la API a una lista de noticias
          final List<dynamic> data = response.data;
          final List<Noticia> news = data.map((json) => Noticia.fromJson(json)).toList();

          // Emite el estado de éxito con las noticias cargadas
          emit(NewsLoadSucces(news));
        } else {
          throw Exception('Failed to load news: ${response.statusCode}');
        }
      } catch (e) {
        // Emite el estado de error si ocurre un problema
        emit(NewsLoadFailure(e.toString()));
      }
    });
  }
  
}
