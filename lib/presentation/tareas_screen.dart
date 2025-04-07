import 'package:flutter/material.dart';
import 'package:dcristaldo/views/login_screen.dart';
import 'package:dcristaldo/views/welcome_screen.dart';
import 'package:dcristaldo/constants.dart';
import 'package:dcristaldo/api/services/task_service.dart';
import 'package:dcristaldo/domain/task.dart';
import 'package:dcristaldo/helpers/task_card_helper.dart'; // Importa el helper para los Cards

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  //Variables
  final TaskService _taskService = TaskService(); // Instancia del servicio
  late List<Task> tareas; // Lista de tareas obtenida del servicio
  final ScrollController _scrollController =
      ScrollController(); // Controlador para el scroll infinito
  bool _isLoading = false; // Indica si se están cargando más tareas
  int _selectedIndex = 0; // Índice seleccionado para la barra de navegación
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Clave global para el formulario

  @override
  void initState() {
    super.initState();
    tareas =
        _taskService.getAllTasks(); // Carga inicial de tareas desde el servicio
    _scrollController.addListener(_onScroll); // Escucha el scroll
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpia el controlador al destruir el widget
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreTasks(); // Carga más tareas al llegar al final del scroll
    }
  }

  void _loadMoreTasks() async {
    setState(() {
      _isLoading = true;
    });

    // Simula la carga de más tareas
    await Future.delayed(const Duration(seconds: 2));
    final newTasks = List.generate(
      5,
      (index) => Task(
        title: 'Tarea ${tareas.length + index + 1}',
        type: 'Normal',
        detail: 'Sin detalles',
      ),
    );

    for (var task in newTasks) {
      _taskService.addTask(
        task.title,
        task.detail,
        DateTime.now(),
      ); // Usa el servicio para agregar las tareas
    }

    setState(() {
      tareas =
          _taskService.getAllTasks(); // Actualiza la lista desde el servicio
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Lógica para manejar la navegación según el índice seleccionado
    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1: // Añadir Tarea
        // Ya estás en TareasScreen, no necesitas navegar
        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  void _agregarTarea(String titulo, String detalle, DateTime fecha) {
    setState(() {
      _taskService.addTask(
        titulo,
        detalle,
        fecha,
      ); // Guarda la tarea en el repositorio a través del servicio
      tareas =
          _taskService.getAllTasks(); // Actualiza la lista desde el repositorio
    });
  }

  void _editarTarea(int index, String titulo, String detalle, DateTime fecha) {
    setState(() {
      _taskService.updateTask(
        index,
        titulo,
        detalle,
        fecha,
      ); // Usa el servicio para editar la tarea
      tareas =
          _taskService.getAllTasks(); // Actualiza la lista desde el servicio
    });
  }

  void _mostrarModalAgregarTarea({int? index}) {
    final TextEditingController tituloController = TextEditingController(
      text: index != null ? tareas[index].title : '',
    );
    final TextEditingController detalleController = TextEditingController(
      text: index != null ? tareas[index].detail : '',
    );
    final TextEditingController fechaController = TextEditingController(
      text:
          index != null
              ? tareas[index].date.toLocal().toString().split(' ')[0]
              : '',
    );
    DateTime? fechaSeleccionada = index != null ? tareas[index].date : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          key: _formKey,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detalleController,
                decoration: const InputDecoration(
                  labelText: 'Detalle',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  hintText: 'Seleccionar Fecha',
                ),
                onTap: () async {
                  DateTime? nuevaFecha = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (nuevaFecha != null) {
                    setState(() {
                      fechaSeleccionada = nuevaFecha;
                      fechaController.text =
                          nuevaFecha.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validación manual
                final titulo = tituloController.text.trim();
                final detalle = detalleController.text.trim();
                final fecha = fechaController.text.trim();

                if (titulo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El título no puede estar vacío'),
                    ),
                  );
                  return;
                }

                if (detalle.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El detalle no puede estar vacío'),
                    ),
                  );
                  return;
                }

                if (fecha.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Debe seleccionar una fecha')),
                  );
                  return;
                }

                if (index == null) {
                  _agregarTarea(titulo, detalle, fechaSeleccionada!);
                } else {
                  _editarTarea(index, titulo, detalle, fechaSeleccionada!);
                }
                Navigator.pop(context); // Cierra el modal y guarda la tarea
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TITLE_APPBAR)),
      body:
          tareas.isEmpty
              ? const Center(
                child: Text(EMPTY_LIST, style: TextStyle(fontSize: 18)),
              )
              : ListView.builder(
                controller: _scrollController, // Controlador para el scroll
                itemCount: tareas.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == tareas.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final tarea = tareas[index];
                  return TaskCardHelper.buildTaskCard(
                    tarea,
                  ); // Usa el helper para construir el Card
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(),
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}
