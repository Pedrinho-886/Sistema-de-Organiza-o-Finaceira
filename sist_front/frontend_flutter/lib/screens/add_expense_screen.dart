import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final int usuarioId;
  const AddExpenseScreen({super.key, required this.usuarioId});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _categoriaSelecionada = 'Alimentação';
  int? _contaSelecionada;
  List<dynamic> _contas = [];
  bool _isLoading = false;
  final _apiService = ApiService();

  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Saúde',
    'Educação',
    'Moradia',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    _carregarContas();
  }

  void _carregarContas() async {
    try {
      final contas = await _apiService.listarContas(widget.usuarioId);
      setState(() {
        _contas = contas;
        if (contas.isNotEmpty) {
          _contaSelecionada = int.parse(contas[0]['id'].toString());
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar contas: $e')),
      );
    }
  }

  void _salvar() async {
    if (_contaSelecionada == null || _valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.adicionarTransacao(
        contaId: _contaSelecionada!,
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
        descricao: _descricaoController.text.isEmpty ? _categoriaSelecionada : _descricaoController.text,
        categoria: _categoriaSelecionada,
        tipo: 'despesa',
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Gasto / Despesa'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _contaSelecionada,
              hint: const Text('Selecione uma conta'),
              decoration: const InputDecoration(labelText: 'Pagar com a conta:'),
              items: _contas.map<DropdownMenuItem<int>>((conta) {
                return DropdownMenuItem<int>(
                  value: int.parse(conta['id'].toString()),
                  child: Text(conta['nome']),
                );
              }).toList(),
              onChanged: (val) => setState(() => _contaSelecionada = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _valorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor Gasto (R\$)',
                prefixIcon: Icon(Icons.money_off, color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: const InputDecoration(labelText: 'Categoria do Gasto'),
              items: _categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => _categoriaSelecionada = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição (Ex: Almoço, Uber...)',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('REGISTRAR DESPESA'),
                  ),
          ],
        ),
      ),
    );
  }
}
