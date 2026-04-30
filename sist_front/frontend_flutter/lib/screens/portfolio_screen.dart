import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Meu Portfólio', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo Carteira
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Total Investido', style: TextStyle(color: Colors.white70, fontSize: 16)),
                   SizedBox(height: 8),
                   Text('R\$ 10.230,50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                   SizedBox(height: 16),
                   Row(
                     children: [
                       Icon(Icons.trending_up, color: Colors.white, size: 20),
                       SizedBox(width: 8),
                       Text('+ R\$ 450,00 (4.5%) este mês', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                     ],
                   )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Ativos na Carteira
            Text(
              'Meus Ativos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            
            _buildAtivoItem(context, 'PETR4', 'Petrobrás', 'Ações', 'R\$ 3.500,00', '+ 2.1%'),
            _buildAtivoItem(context, 'IVVB11', 'S&P 500', 'ETF', 'R\$ 4.200,50', '+ 0.8%'),
            _buildAtivoItem(context, 'IPCA+35', 'Tesouro Direto', 'Renda Fixa', 'R\$ 2.530,00', '+ 0.4%'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo Ativo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAtivoItem(BuildContext context, String ticker, String nome, String categoria, String saldo, String rentabilidade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(ticker.substring(0, 1), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        title: Text(ticker, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        subtitle: Text('$nome • $categoria', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(saldo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
            Text(rentabilidade, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
