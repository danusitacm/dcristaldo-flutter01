import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcristaldo/bloc/categoria/categoria_bloc.dart';
import 'package:dcristaldo/bloc/categoria/categoria_event.dart';
import 'package:dcristaldo/bloc/categoria/categoria_state.dart';
import 'package:dcristaldo/components/floating_add_button.dart';
import 'package:dcristaldo/components/last_updated_header.dart';
import 'package:dcristaldo/constants/constantes.dart';
import 'package:dcristaldo/components/categoria_card.dart';
import 'package:dcristaldo/components/side_menu.dart';
import 'package:dcristaldo/components/formulario_categoria.dart';
import 'package:dcristaldo/domain/categoria.dart';
import 'package:dcristaldo/helpers/modal_helper.dart';
import 'package:dcristaldo/helpers/snackbar_helper.dart';
import 'package:dcristaldo/helpers/snackbar_manager.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoriaBloc>(
          create:
              (context) =>
                  CategoriaBloc()
                    ..add(CategoriaInitEvent(forzarRecarga: false)),
        ),
      ],
      child: _CategoriaScreenContent(),
    );
  }
}

class _CategoriaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriaBloc, CategoriaState>(
      listenWhen: (previous, current) {
        return current is CategoriaError ||
            current is CategoriaCreated ||
            current is CategoriaUpdated ||
            current is CategoriaReloaded ||
            (current is CategoriaLoaded && current.categorias.isEmpty);
      },
      listener: (context, state) {
        if (state is CategoriaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is CategoriaCreated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: CategoriaConstantes.successCreated,
          );
        } else if (state is CategoriaUpdated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: CategoriaConstantes.successUpdated,
          );
        } else if (state is CategoriaReloaded) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Categorías recargadas correctamente',
          );
        } else if (state is CategoriaLoaded && state.categorias.isEmpty) {
          SnackBarHelper.mostrarInfo(
            context,
            mensaje: CategoriaConstantes.listaVacia,
          );
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is CategoriaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Categorías de Noticias'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed:
                    () => context.read<CategoriaBloc>().add(
                      CategoriaInitEvent(forzarRecarga: true),
                    ),
              ),
            ],
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoCategorias(context, state)),
            ],
          ),
          floatingActionButton: FloatingAddButton(
            onPressed: () async {
              final categoria = await ModalHelper.mostrarDialogo<Categoria>(
                context: context,
                title: 'Agregar Categoría',
                child: const FormularioCategoria(),
              );

              if (categoria != null && context.mounted) {
                context.read<CategoriaBloc>().add(
                  CategoriaCreateEvent(categoria),
                );
              }
            },
            tooltip: 'Agregar Categoría',
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _construirCuerpoCategorias(
    BuildContext context,
    CategoriaState state,
  ) {
    Future<void> onRefresh() async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (context.mounted) {
        context.read<CategoriaBloc>().add(
          CategoriaInitEvent(forzarRecarga: false),
        );
      }
    }

    Widget buildRefreshableList({required Widget child}) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [child],
        ),
      );
    }

    if (state is CategoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CategoriaError) {
      return buildRefreshableList(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<CategoriaBloc>().add(
                        CategoriaInitEvent(forzarRecarga: true),
                      ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (state is CategoriaLoaded) {
      if (state.categorias.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return CategoriaCard(
                categoria: categoria,
                onEdit: () => _editarCategoria(context, categoria),
              );
            },
          ),
        );
      } else {
        return buildRefreshableList(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: Text(CategoriaConstantes.listaVacia)),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Future<void> _editarCategoria(
    BuildContext context,
    Categoria categoria,
  ) async {
    final categoriaEditada = await ModalHelper.mostrarDialogo<Categoria>(
      context: context,
      title: 'Editar Categoría',
      child: FormularioCategoria(categoria: categoria),
    );

    if (categoriaEditada != null && context.mounted) {
      final categoriaActualizada = categoriaEditada.copyWith(id: categoria.id);
      context.read<CategoriaBloc>().add(
        CategoriaUpdateEvent(categoriaActualizada),
      );
    }
      
    }
}
