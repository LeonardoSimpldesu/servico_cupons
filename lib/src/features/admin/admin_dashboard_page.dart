import 'package:flutter/material.dart';
import 'package:trying_flutter/src/features/admin/widgets/admin_drawer.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
      ),
      drawer: const AdminDrawer(),
      body: const Center(
        child: Text(
          'Bem-vindo ao Painel do Administrador!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}