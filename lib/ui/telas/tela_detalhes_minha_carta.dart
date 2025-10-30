import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../model/hero_model.dart';
import '../../service/local_storage_service.dart'; // ajuste o caminho se necessário

class TelaDetalhesMinhaCarta extends StatelessWidget {
  final HeroModel heroi;
  final LocalStorageService storageService = LocalStorageService();

  TelaDetalhesMinhaCarta({super.key, required this.heroi});

  void _confirmarAbandono(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Abandonar Carta',
      desc: 'Tem certeza que deseja remover esta carta da sua coleção?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await storageService.removerCarta(heroi.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carta removida com sucesso!')),
          );
        }
      },
      btnOkText: "Sim",
      btnCancelText: "Cancelar",
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(heroi.name),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: heroi.imageUrl,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 60, color: Colors.red),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red, width: 3),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _confirmarAbandono(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Abandonar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
