import 'package:flutter/material.dart';
import 'link_service.dart';

class LinkPage extends StatefulWidget {
  final bool isGuest;
  const LinkPage({super.key, required this.isGuest});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  final TextEditingController codeController = TextEditingController();
  String username = 'Usuario SOSA';

  @override
  Widget build(BuildContext context) {
    if (widget.isGuest) {
      return _guestBlocked();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vinculación SOSA')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LinkService.isLinked()
            ? _linkedView()
            : _unlinkedView(),
      ),
    );
  }

  Widget _guestBlocked() {
    return Scaffold(
      appBar: AppBar(title: const Text('Vinculación')),
      body: const Center(
        child: Text(
          'Debes registrarte para vincular usuarios',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _unlinkedView() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.qr_code),
          label: const Text('Generar código de vinculación'),
          onPressed: () {
            setState(() {
              LinkService.createLink(username);
            });
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Ingresar código',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          child: const Text('Vincularme'),
          onPressed: () {
            bool ok = LinkService.joinLink(
              codeController.text.trim(),
              username,
            );

            if (ok) {
              setState(() {});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código inválido')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _linkedView() {
    final link = LinkService.currentLink!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código vinculado:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        SelectableText(
          link.code,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text('Usuarios vinculados:'),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
            ),
            itemCount: link.members.length,
            itemBuilder: (_, i) {
              return Card(
                child: Center(child: Text(link.members[i])),
              );
            },
          ),
        ),
      ],
    );
  }
}
