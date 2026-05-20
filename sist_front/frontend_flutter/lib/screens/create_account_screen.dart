import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateAccountScreen extends StatefulWidget {
  final int usuarioId;
  const CreateAccountScreen({super.key, required this.usuarioId});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nomeController = TextEditingController();
  final _saldoController = TextEditingController(text: '0.00');
  bool _isLoading = false;
  final _apiService = ApiService();

  void _salvar() async {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dê um nome para a conta (ex: Nubank, Carteira)')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.criarConta(
        usuarioId: widget.usuarioId,
        nome: _nomeController.text,
        saldoInicial: double.parse(_saldoController.text.replaceAll(',', '.')),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar conta: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Conta Bancária')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Como você quer chamar essa conta?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                hintText: 'Ex: Nubank, Banco do Brasil, Carteira',
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Saldo inicial (opcional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _saldoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'R\$ ',
              ),
            ),
            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('CRIAR CONTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
