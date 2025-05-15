import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../temas/gestion_temas.dart';

class IconoSelectorTema extends StatelessWidget {
  const IconoSelectorTema({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GestorTemaAplicacion>(
      builder: (context, gestorTema, child) {
        return IconButton(
          icon: Consumer<GestorTemaAplicacion>(
            builder: (context, gestorTema, _) {
              final usaModoOscuro =
                  gestorTema.modoDeTema == ThemeMode.dark ||
                  (gestorTema.modoDeTema == ThemeMode.system &&
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);

              return Icon(usaModoOscuro ? Icons.light_mode : Icons.dark_mode);
            },
          ),
          onPressed:
              () =>
                  Provider.of<GestorTemaAplicacion>(
                    context,
                    listen: false,
                  ).cambiarTema(),
        );
      },
    );
  }
}
