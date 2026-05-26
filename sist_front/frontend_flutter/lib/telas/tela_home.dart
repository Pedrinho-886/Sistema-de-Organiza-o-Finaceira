import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_adicionar_receita.dart';
import 'tela_adicionar_despesa.dart';
import 'tela_criar_conta.dart';
import '../servicos/servico_api.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final int usuarioId;
  const HomeScreen({super.key, required this.usuarioId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _contas = [];
  List<dynamic> _transacoes = [];
  double _patrimonioTotal = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      final contas = await _apiService.listarContas(widget.usuarioId);
      final transacoes = await _apiService.listarTodasTransacoes(widget.usuarioId);
      
      double total = 0;
      for (var conta in contas) {
        total += double.parse(conta['saldo'].toString());
      }
      
      setState(() {
        _contas = contas;
        _transacoes = transacoes;
        _patrimonioTotal = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  String _formatarMoeda(double valor) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(valor);
  }

  String _formatarData(String dataString) {
    final DateTime data = DateTime.parse(dataString).toLocal();
    final DateTime agora = DateTime.now();
    
    if (data.day == agora.day && data.month == agora.month && data.year == agora.year) {
      return 'Hoje, ${DateFormat.Hm().format(data)}';
    }
    return DateFormat('dd/MM, HH:mm').format(data);
  }

  void _mostrarOpcoesConta(dynamic conta) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar Conta'),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoEdicaoConta(conta);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir Conta', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmarExclusaoConta(conta);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEdicaoConta(dynamic conta) {
    final _nomeController = TextEditingController(text: conta['nome']);
    final _saldoController = TextEditingController(text: conta['saldo'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Conta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da Conta'),
            ),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Saldo Atual'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.atualizarConta(
                  id: conta['id'],
                  nome: _nomeController.text,
                  saldo: double.parse(_saldoController.text),
                );
                Navigator.pop(context);
                _carregarDados();
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

  void _confirmarExclusaoConta(dynamic conta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: Text('Tem certeza que deseja excluir a conta "${conta['nome']}"? Todas as transações vinculadas serão apagadas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _apiService.excluirConta(conta['id']);
                Navigator.pop(context);
                _carregarDados();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Visão Geral',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 16,
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patrimônio Total',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    _isLoading 
                      ? const SizedBox(height: 40, child: CircularProgressIndicator(color: Colors.white))
                      : Text(
                          _formatarMoeda(_patrimonioTotal),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minhas Contas',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(
                                usuarioId: widget.usuarioId)),
                      );
                      if (result == true) _carregarDados();
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Nova'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _contas.isEmpty
                      ? const Center(child: Text("Nenhuma conta cadastrada."))
                      : Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _contas.length,
                            itemBuilder: (context, index) {
                              final conta = _contas[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onLongPress: () => _mostrarOpcoesConta(conta),
                                  child: _buildRealContaItem(
                                    context,
                                    Icons.account_balance,
                                    conta['nome'],
                                    _formatarMoeda(double.parse(conta['saldo'].toString())),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              const SizedBox(height: 32),

              Text(
                'Últimas Movimentações',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _transacoes.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("Nenhuma movimentação ainda.")),
                    )
                  : Column(
                      children: _transacoes.take(10).map((t) {
                        bool isDespesa = t['tipo'].toString().toLowerCase() == 'despesa';
                        return _buildRealTransacao(
                          context,
                          t['descricao'],
                          '${_formatarData(t['data'])} • ${t['nome_conta']}',
                          '${isDespesa ? '-' : '+'} ${_formatarMoeda(double.parse(t['valor'].toString()))}',
                          isDespesa,
                          t['categoria'],
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn_despesa',
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddExpenseScreen(usuarioId: widget.usuarioId),
                ),
              );
              if (result == true) _carregarDados();
            },
            label: const Text('Novo Gasto', style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.remove, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'btn_receita',
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddIncomeScreen(usuarioId: widget.usuarioId),
                ),
              );
              if (result == true) _carregarDados();
            },
            label: const Text('Novo Saldo', style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRealContaItem(
      BuildContext context, IconData icon, String nome, String saldo) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(nome,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(saldo,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildRealTransacao(
      BuildContext context, String titulo, String data, String valor, bool isDespesa, String categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDespesa
                ? Colors.red.withOpacity(0.1)
                : Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDespesa ? Icons.arrow_downward : Icons.arrow_upward,
            color: isDespesa
                ? Colors.redAccent
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data, style: const TextStyle(fontSize: 12)),
            Text(categoria, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        trailing: Text(
          valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDespesa
                ? Colors.redAccent
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
