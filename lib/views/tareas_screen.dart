import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_bloc.dart';
import 'package:dcristaldo/bloc/tareas/tareas_event.dart';
import 'package:dcristaldo/bloc/tareas/tareas_state.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:dcristaldo/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/views/task_details_screen.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/helpers/task_card_helper.dart';
import 'package:dcristaldo/components/add_task_modal.dart';
import 'package:dcristaldo/components/task_progress_indicator.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TareasBloc()..add(const TareasLoadEvent(forzarRecarga: false)),
        ),
        BlocProvider(create: (context) => TareaContadorBloc()),
      ],
      child: const TareaScreenContent(),
    );
  }
}

class TareaScreenContent extends StatefulWidget {
  const TareaScreenContent({super.key});
  static const int _limiteTareas = 3;

  @override
  State<TareaScreenContent> createState() => _TareaScreenContentState();
}

class _TareaScreenContentState extends State<TareaScreenContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actualizarContador();
    });
  }

  void _actualizarContador() {
    final tareasState = context.read<TareasBloc>().state;
    final contadorBloc = context.read<TareaContadorBloc>();

    if (tareasState.tareas.isNotEmpty) {
      contadorBloc.add(TareaContadorCargarEvent(tareasState.tareas));
    }
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    final tareasBloc = context.read<TareasBloc>();
    final cantidadTareas = tareasBloc.state.tareas.length;    
    if (cantidadTareas >= TareaScreenContent._limiteTareas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pueden agregar más tareas. Límite de 3 tareas alcanzado.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: tareasBloc,
            child: AddTaskModal(
              onTaskAdded: (Task nuevaTarea) {
                tareasBloc.add(TareasAddEvent(tarea: nuevaTarea));

                Future.delayed(
                  const Duration(milliseconds: 300),
                  _actualizarContador,
                );
              },
            ),
          ),
    );
  }

  void _cargarTareasDesdeAPI(BuildContext context) {
    final tareasBloc = context.read<TareasBloc>();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cargando tareas desde la API...'),
        duration: Duration(seconds: 2),
      ),
    );
    tareasBloc.add(const TareasLoadEvent(forzarRecarga: true));
    Future.delayed(
      const Duration(milliseconds: 500),
      _actualizarContador,
    );
  }

  void _mostrarDetallesTarea(
    BuildContext context,
    List<Task> tareas,
    int indice,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(tareas: tareas, indice: indice),
      ),
    );
  }

  void _eliminarTarea(BuildContext context, int index) {
    context.read<TareasBloc>().add(TareasDeleteEvent(index: index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(TareasConstantes.tareaEliminada)),
    );

    Future.delayed(const Duration(milliseconds: 300), _actualizarContador);
  }

  void _mostrarModalEditarTarea(BuildContext context, Task tarea, int index) {
    final tareasBloc = context.read<TareasBloc>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: tareasBloc,
            child: AddTaskModal(
              taskToEdit: tarea,
              onTaskAdded: (Task tareaEditada) {
                tareasBloc.add(
                  TareasUpdateEvent(index: index, tarea: tareaEditada),
                );

                Future.delayed(
                  const Duration(milliseconds: 300),
                  _actualizarContador,
                );
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TareasBloc, TareasState>(
          listenWhen: (previous, current) => current.tareaCompletada != null,
          listener: (context, state) {
            if (state.tareaCompletada != null && state.completada != null) {
              final mensaje =
                  state.completada!
                      ? '¡Tarea "${state.tareaCompletada!.titulo}" completada!'
                      : 'Tarea "${state.tareaCompletada!.titulo}" marcada como pendiente';

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(mensaje)));

              final contadorBloc = context.read<TareaContadorBloc>();
              contadorBloc.add(
                TareaContadorActualizarEvent(
                  tarea: state.tareaCompletada!,
                  completada: state.completada!,
                ),
              );
            }
          },
        ),
        BlocListener<TareasBloc, TareasState>(
          listenWhen:
              (previous, current) =>
                  previous.tareas.length != current.tareas.length ||
                  current.status == TareasStatus.loaded,
          listener: (context, state) {
            if (state.tareas.isNotEmpty) {
              final contadorBloc = context.read<TareaContadorBloc>();
              contadorBloc.add(TareaContadorCargarEvent(state.tareas));
            }
          },
        ),
      ],
      child: BlocBuilder<TareasBloc, TareasState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}/${TareaScreenContent._limiteTareas}',
              ),
              actions: [
                if (state.tareas.length < TareaScreenContent._limiteTareas)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'Disponibles: ${TareaScreenContent._limiteTareas - state.tareas.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            drawer: const SideMenu(),
            backgroundColor: Colors.grey[200],
            body: Column(
              children: [
                const TaskProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: state.status == TareasStatus.loading 
                      ? null 
                      : () => _cargarTareasDesdeAPI(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Cargar tareas desde API'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(child: _buildBody(state)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: state.tareas.length >= TareaScreenContent._limiteTareas 
                  ? null 
                  : () => _mostrarModalAgregarTarea(context),
              tooltip: state.tareas.length >= TareaScreenContent._limiteTareas 
                  ? 'Límite de tareas alcanzado' 
                  : 'Agregar Tarea',
              backgroundColor: state.tareas.length >= TareaScreenContent._limiteTareas 
                  ? Colors.grey 
                  : null,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(TareasState state) {
    switch (state.status) {
      case TareasStatus.initial:
      case TareasStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case TareasStatus.loaded:
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
      itemCount: state.tareas.length,
      itemBuilder: (context, index) {
        final tarea = state.tareas[index];
        return GestureDetector(
          onTap: () => _mostrarDetallesTarea(context, state.tareas, index),
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
              _eliminarTarea(context, index);
            },
            child: construirTarjetaDeportiva(
              tarea,
              index,
              () => _mostrarModalEditarTarea(context, tarea, index),
            ),
          ),
        );
      },
    );
  }
}
