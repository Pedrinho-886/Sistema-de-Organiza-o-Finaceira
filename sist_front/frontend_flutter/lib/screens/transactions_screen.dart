import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Transações e Categorias', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Column(
        children: [
          // Filtros e Categorias
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(context, 'Todas', true),
                  _buildFilterChip(context, 'Alimentação', false),
                  _buildFilterChip(context, 'Transporte', false),
                  _buildFilterChip(context, 'Moradia', false),
                  _buildFilterChip(context, 'Lazer', false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Resumo do Mês
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mês Atual (Abril)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                Text('- R\$ 3.450,00', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Lista de Transações mockada para UI visual
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 8,
              itemBuilder: (context, index) {
                bool isReceita = index == 2 || index == 5;
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
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isReceita ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isReceita ? Icons.arrow_downward : Icons.fastfood,
                        color: isReceita ? Theme.of(context).colorScheme.primary : Colors.redAccent,
                      ),
                    ),
                    title: Text(
                      isReceita ? 'Salário ou Depósito' : 'Restaurante / Padaria', 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)
                    ),
                    subtitle: Text(
                      isReceita ? 'Renda' : 'Alimentação • Cartão Nubank',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))
                    ),
                    trailing: Text(
                      isReceita ? '+ R\$ 2.000,00' : '- R\$ 45,90',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isReceita ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nova Transação', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
          )
        ),
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
