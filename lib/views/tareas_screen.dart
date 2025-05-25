import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_event.dart';
import 'package:dcristaldo/bloc/tareas/tareas_state.dart';
import 'package:dcristaldo/components/custom_bottom_navigation_bar.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/views/task_details_screen.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/helpers/task_card_helper.dart';
import 'package:dcristaldo/components/add_task_modal.dart'; // Importa el modal reutilizable

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TareasBloc()..add(const TareasLoadEvent()),
      child: const TareaScreenContent(),
    );
  }
}

class TareaScreenContent extends StatefulWidget {
  const TareaScreenContent({super.key});

  @override
  TareaScreenContentState createState() => TareaScreenContentState();
}

class TareaScreenContentState extends State<TareaScreenContent> {
  final ScrollController _scrollController = ScrollController();
  final int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TareasBloc>().add(const TareasLoadMoreEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _mostrarModalAgregarTarea() {
    // Obtenemos el TareasBloc actual antes de mostrar el modal
    final tareasBloc = context.read<TareasBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: tareasBloc,
        child: AddTaskModal(
          onTaskAdded: (Task nuevaTarea) {
            tareasBloc.add(TareasAddEvent(tarea: nuevaTarea));
          },
        ),
      ),
    );
  }

  void _mostrarDetallesTarea(List<Task> tareas, int indice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          tareas: tareas, 
          indice: indice
        ),
      ),
    );
  }

  void _eliminarTarea(int index) {
    context.read<TareasBloc>().add(TareasDeleteEvent(index: index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(TareasConstantes.tareaEliminada)),
    );
  }

  void _mostrarModalEditarTarea(Task tarea, int index) {
    // Obtenemos el TareasBloc actual antes de mostrar el modal
    final tareasBloc = context.read<TareasBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: tareasBloc,
        child: AddTaskModal(
          taskToEdit: tarea,
          onTaskAdded: (Task tareaEditada) {
            tareasBloc.add(TareasUpdateEvent(index: index, tarea: tareaEditada));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TareasBloc, TareasState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}')
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.grey[200],
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: _mostrarModalAgregarTarea,
            tooltip: 'Agregar Tarea',
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
        );
      },
    );
  }

  Widget _buildBody(TareasState state) {
    switch (state.status) {
      case TareasStatus.initial:
      case TareasStatus.loading:
        return const Center(child: CircularProgressIndicator());
      
      case TareasStatus.loaded:
      case TareasStatus.loadingMore:
        if (state.tareas.isEmpty) {
          return const Center(
            child: Text(
              TareasConstantes.listaVacia,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }
        return _buildTareasList(state);
        
      case TareasStatus.error:
        return Center(
          child: Text(
            'Error: ${state.errorMessage}',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  Widget _buildTareasList(TareasState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.tareas.length + (state.status == TareasStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.tareas.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final tarea = state.tareas[index];
        return GestureDetector(
          onTap: () => _mostrarDetallesTarea(state.tareas, index),
          child: Dismissible(
            key: Key(tarea.titulo),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _eliminarTarea(index);
            },
            child: construirTarjetaDeportiva(
              tarea, 
              index,
              () => _mostrarModalEditarTarea(tarea, index),
            ),
          ),
        );
      },
    );
  }
}
