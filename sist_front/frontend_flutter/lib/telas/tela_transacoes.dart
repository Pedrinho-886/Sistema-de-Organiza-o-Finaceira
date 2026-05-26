import 'package:flutter/material.dart';
import '../servicos/servico_api.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  final int usuarioId;
  const TransactionsScreen({super.key, required this.usuarioId});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _todasTransacoes = [];
  List<dynamic> _transacoesFiltradas = [];
  bool _isLoading = true;
  
  DateTime _mesSelecionado = DateTime.now();
  String _categoriaSelecionada = 'Todas';

  final List<String> _categorias = [
    'Todas',
    'Salário',
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
    _carregarTransacoes();
  }

  Future<void> _carregarTransacoes() async {
    setState(() => _isLoading = true);
    try {
      final transacoes = await _apiService.listarTodasTransacoes(widget.usuarioId);
      setState(() {
        _todasTransacoes = transacoes;
        _filtrarTransacoes();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar transações: $e')),
      );
    }
  }

  void _filtrarTransacoes() {
    setState(() {
      _transacoesFiltradas = _todasTransacoes.where((t) {
        final dataT = DateTime.parse(t['data']);
        bool mesmoMes = dataT.month == _mesSelecionado.month && dataT.year == _mesSelecionado.year;
        bool mesmaCategoria = _categoriaSelecionada == 'Todas' || t['categoria'] == _categoriaSelecionada;
        return mesmoMes && mesmaCategoria;
      }).toList();
    });
  }

  void _mudarMes(int offset) {
    setState(() {
      _mesSelecionado = DateTime(_mesSelecionado.year, _mesSelecionado.month + offset);
      _filtrarTransacoes();
    });
  }

  String _formatarMoeda(double valor) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(valor);
  }

  double _calcularTotalMes() {
    double total = 0;
    for (var t in _transacoesFiltradas) {
      double valor = double.parse(t['valor'].toString());
      if (t['tipo'].toString().toLowerCase() == 'despesa') {
        total -= valor;
      } else {
        total += valor;
      }
    }
    return total;
  }

  Future<void> _excluirTransacao(int id) async {
    try {
      await _apiService.excluirTransacao(id);
      _carregarTransacoes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação excluída')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  void _mostrarDialogoEdicao(dynamic transacao) {
    final _descricaoController = TextEditingController(text: transacao['descricao']);
    final _valorController = TextEditingController(text: transacao['valor'].toString());
    String _cat = transacao['categoria'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Transação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor'),
            ),
            DropdownButtonFormField<String>(
              value: _cat,
              items: _categorias.where((c) => c != 'Todas').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => _cat = val!,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.atualizarTransacao(
                  id: transacao['id'],
                  contaId: transacao['conta_id'],
                  valor: double.parse(_valorController.text),
                  descricao: _descricaoController.text,
                  categoria: _cat,
                  tipo: transacao['tipo'],
                );
                Navigator.pop(context);
                _carregarTransacoes();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nomeMes = DateFormat('MMMM yyyy', 'pt_BR').format(_mesSelecionado);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Histórico de Transações', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarTransacoes),
        ],
      ),
      body: Column(
        children: [
          // Selecionador de Mês
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _mudarMes(-1)),
                Text(
                  nomeMes.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _mudarMes(1)),
              ],
            ),
          ),

          // Filtro de Categorias
          Container(
            height: 60,
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final cat = _categorias[index];
                final isSelected = _categoriaSelecionada == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _categoriaSelecionada = cat;
                        _filtrarTransacoes();
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Resumo Financeiro do Filtro
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Balanço do Período:', style: TextStyle(fontSize: 16)),
                Text(
                  _formatarMoeda(_calcularTotalMes()),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _calcularTotalMes() >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Lista de Transações
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _transacoesFiltradas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('Nenhuma transação em $nomeMes'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _transacoesFiltradas.length,
                        itemBuilder: (context, index) {
                          final t = _transacoesFiltradas[index];
                          final bool isDespesa = t['tipo'].toString().toLowerCase() == 'despesa';
                          final DateTime data = DateTime.parse(t['data']);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isDespesa ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                child: Icon(
                                  isDespesa ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isDespesa ? Colors.red : Colors.green,
                                ),
                              ),
                              title: Text(t['descricao'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${DateFormat('dd/MM/yyyy').format(data)} • ${t['nome_conta']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatarMoeda(double.parse(t['valor'].toString())),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDespesa ? Colors.red : Colors.green,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _mostrarDialogoEdicao(t);
                                      } else if (value == 'delete') {
                                        _excluirTransacao(t['id']);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                                      const PopupMenuItem(value: 'delete', child: Text('Excluir')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
