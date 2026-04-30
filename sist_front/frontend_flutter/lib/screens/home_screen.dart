import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Visão Geral', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Sair', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 16,
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patrimônio Total',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'R\$ 45.230,00',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Componente de Acesso Rápido / Contas UI
            Text(
              'Minhas Contas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildContaItem(context, Icons.account_balance, 'Nubank', 'R\$ 12.000'),
                  _buildContaItem(context, Icons.wallet, 'Carteira', 'R\$ 230'),
                  _buildContaItem(context, Icons.credit_card, 'Cartões', 'Faturas'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Transações Rápidas
            Text(
              'Últimas Movimentações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            _buildTransacao(context, 'Mercado Livre', 'Hoje', '- R\$ 120,50', true),
            _buildTransacao(context, 'Salário', 'Ontem', '+ R\$ 8.500,00', false),
            _buildTransacao(context, 'Uber', '2 dias atrás', '- R\$ 24,90', true),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContaItem(BuildContext context, IconData icon, String nome, String subtitulo) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        ),
        const SizedBox(height: 8),
        Text(nome, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        Text(subtitulo, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildTransacao(BuildContext context, String titulo, String data, String valor, bool isDespesa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDespesa ? Colors.red.withOpacity(0.1) : Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDespesa ? Icons.arrow_downward : Icons.arrow_upward,
            color: isDespesa ? Colors.redAccent : Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        subtitle: Text(data, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        trailing: Text(
          valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDespesa ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
