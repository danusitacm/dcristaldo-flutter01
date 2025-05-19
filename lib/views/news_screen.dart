import 'package:dcristaldo/bloc/category/category_bloc.dart';
import 'package:dcristaldo/bloc/category/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/news/news_bloc.dart';
import 'package:dcristaldo/components/noticia_card.dart';
import 'package:dcristaldo/domain/noticia.dart';
import 'package:dcristaldo/views/base_screen.dart';
import 'package:dcristaldo/components/news_form_dialog.dart';
import 'package:dcristaldo/components/delete_confirmation_dialog.dart';
import 'package:dcristaldo/components/report_form_dialog.dart';
import 'package:dcristaldo/bloc/preferencia/preferencia_bloc.dart';
import 'package:dcristaldo/bloc/preferencia/preferencia_event.dart';
import 'package:dcristaldo/views/preferencia_screen.dart';
import 'package:dcristaldo/bloc/reporte/reporte_bloc.dart';
import 'package:dcristaldo/bloc/reporte/reporte_event.dart';
import 'package:dcristaldo/bloc/reporte/reporte_state.dart';
import 'package:dcristaldo/domain/reporte.dart';
import 'package:intl/intl.dart';
import 'package:dcristaldo/components/comentario_dialog.dart';
import 'package:dcristaldo/bloc/comentarios/comentario_bloc.dart';


class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurarnos de que las preferencias se cargan primero
    // y luego las noticias, para evitar problemas de sincronización
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        debugPrint('🔄 NewsScreen: Iniciando carga de preferencias...');
        context.read<PreferenciaBloc>().add(const CargarPreferencias());
        
        // Pequeño delay para asegurar que las preferencias se cargan primero
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            debugPrint('🔄 NewsScreen: Iniciando carga de noticias y categorías...');
            context.read<NewsBloc>().add(const NewsStarted());
            context.read<NewsBloc>().add(const NewsCategoriesRequested());
          }
        });
      }
    });
    
    return BlocListener<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte enviado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ReporteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BaseScreen(
        appBar: AppBar(
          title: const Text('Noticias'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _navigateToPreferenciasScreen(context),
              tooltip: 'Filtrar por categorías',
            ),
          ],
        ),
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: _handleStateChanges,
          builder: (context, state) => _buildBody(context, state),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddNewsDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _navigateToPreferenciasScreen(BuildContext context) async {
    context.read<CategoriaBloc>().add(CategoriaInitEvent());
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PreferenciasScreen(),
      ),
    );
    if (context.mounted) {
      context.read<NewsBloc>().add(const NewsStarted());
    }
  }

  void _handleStateChanges(BuildContext context, NewsState state) {
    if (state is NewsLoadFailure) {
      
    } else if (state is NewsLoadSucces) {
      // Opcional: Mostrar un mensaje de éxito después de operaciones CRUD
    }
  }

  Widget _buildBody(BuildContext context, NewsState state) {
    final preferenciaState = context.watch<PreferenciaBloc>().state;
    final filtrosActivos = preferenciaState.categoriasSeleccionadas.isNotEmpty;
    
    if (state is NewsLoadInProgress) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsLoadSucces) {
      final allNews = state.news;
      
      // Filtrar noticias según las preferencias del usuario
      final filteredNews = filtrosActivos 
          ? allNews.where((noticia) => 
              preferenciaState.categoriasSeleccionadas.contains(noticia.categoriaId))
              .toList()
          : allNews;
          
      debugPrint('📱 NewsScreen: Noticias después de filtrar: ${filteredNews.length}');
      
      // Si no hay noticias después del filtrado, mostramos mensaje adecuado
      if (filteredNews.isEmpty) {
        debugPrint('⚠️ NewsScreen: No hay noticias después del filtrado');
        
        // Si allNews también está vacío, significa que no hay noticias en general
        if (allNews.isEmpty) {
          debugPrint('⚠️ NewsScreen: No hay noticias disponibles en la aplicación');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No hay noticias disponibles en este momento.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        // Si hay noticias pero el filtrado las eliminó todas
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No hay noticias disponibles con los filtros actuales.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              if (filtrosActivos) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<PreferenciaBloc>().add(const ReiniciarFiltros()),
                  icon: const Icon(Icons.filter_list_off),
                  label: const Text('Quitar filtros'),
                ),
              ]
            ],
          ),
        );
      }

      return Column(
        children: [
          // Mostrar indicador de filtros activos
          if (filtrosActivos)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.blue,
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mostrando ${filteredNews.length} de ${allNews.length} noticias',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<PreferenciaBloc>().add(const ReiniciarFiltros()),
                    child: const Text('Quitar filtros'),
                  )
                ],
              ),
            ),
          // Lista de noticias filtradas
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(const NewsStarted());
              },
              child: ListView.builder(
                itemCount: filteredNews.length,
                itemBuilder: (context, index) {
                  final news = filteredNews[index];
                  return NoticiaCard(
                    noticia: news,
                    categorias: state.categorias,
                    onEdit: () => _showEditNewsDialog(context, news),
                    onDelete: () => _showDeleteNewsDialog(context, news.id!),
                    onReport: () => _showReportDialog(context, news.id!),
                    onComment: () => _showComentariosDialog(context, news),
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else if (state is NewsLoadFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<NewsBloc>().add(const NewsStarted());
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No hay noticias disponibles.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
  
  /// Método para mostrar el diálogo de agregar noticia
  void _showAddNewsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NewsFormDialog(),
    );
  }
  
  /// Método para mostrar el diálogo de editar noticia
  void _showEditNewsDialog(BuildContext context, Noticia noticia) {
    showDialog(
      context: context,
      builder: (context) => NewsFormDialog(noticia: noticia),
    );
  }
  
  /// Método para mostrar el diálogo de eliminar noticia
  void _showDeleteNewsDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Eliminar Noticia',
        message: '¿Estás seguro de que deseas eliminar esta noticia?',
        onDelete: () => context.read<NewsBloc>().add(NewsDeleted(id)),
      ),
    );
  }
  void _showReportDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => ReportFormDialog(
        noticiaId: id,
        title: 'Reportar Noticia',
        onReport: () => context.read<ReporteBloc>().add(ReporteSubmitted(
          Reporte(
            noticiaId: id,
            fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            motivo: MotivoReporte.noticiaInapropiada, // El motivo se maneja internamente en ReportFormDialog
          )
        )),
      ),
    );
  }
  
  /// Método para mostrar el diálogo de comentarios
  void _showComentariosDialog(BuildContext context, Noticia noticia) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => ComentarioBloc(),
        child: ComentarioDialog(
          noticiaId: noticia.id!,
          titulo: noticia.titulo,
        ),
      ),
    );
  }
}