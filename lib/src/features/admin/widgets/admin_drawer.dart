import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Administrador'),
            accountEmail: Text('admin@cupomapp.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          
          // Item 1: Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); 
              context.go('/dashboard');
            },
          ),

          // Item 2: Cadastrar Cupom
          ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: const Text('Cadastrar Cupom'),
            onTap: () {
              Navigator.pop(context);
              context.go('/create-coupon'); 
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}