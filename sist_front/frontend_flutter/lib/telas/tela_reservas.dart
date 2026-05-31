import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/tema_app.dart';
import '../servicos/servico_api.dart';
import '../modelos/reserva.dart';

class ReservesScreen extends StatefulWidget {
  final int usuarioId;
  const ReservesScreen({super.key, required this.usuarioId});

  @override
  State<ReservesScreen> createState() => _ReservesScreenState();
}

class _ReservesScreenState extends State<ReservesScreen> {
  final ApiService _apiService = ApiService();
  List<Reserva> _reservas = [];
  bool _isLoading = true;
  double _totalGuardado = 0.0;

  @override
  void initState() {
    super.initState();
    _carregarReservas();
  }

  Future<void> _carregarReservas() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.listarReservas(widget.usuarioId);
      double total = 0;
      List<Reserva> lista = data.map((item) {
        final r = Reserva.fromMap(item);
        total += r.valorAcumulado;
        return r;
      }).toList();

      setState(() {
        _reservas = lista;
        _totalGuardado = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar reservas: $e')),
        );
      }
    }
  }

  String _formatarMoeda(double valor) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(valor);
  }

  void _mostrarDialogoReserva({Reserva? reserva}) {
    final nomeController = TextEditingController(text: reserva?.nomeMeta ?? '');
    final metaController = TextEditingController(text: reserva?.valorMeta.toString() ?? '');
    final acumuladoController = TextEditingController(text: reserva?.valorAcumulado.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reserva == null ? 'Nova Meta' : 'Editar Meta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Meta (ex: Carro, Viagem)'),
              ),
              TextField(
                controller: metaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor Objetivo (Meta)'),
              ),
              TextField(
                controller: acumuladoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor Já Guardado'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                if (reserva == null) {
                  await _apiService.criarReserva(
                    usuarioId: widget.usuarioId,
                    nomeMeta: nomeController.text,
                    valorMeta: double.parse(metaController.text),
                    valorAcumulado: double.parse(acumuladoController.text),
                  );
                } else {
                  await _apiService.atualizarReserva(
                    id: reserva.id,
                    nomeMeta: nomeController.text,
                    valorMeta: double.parse(metaController.text),
                    valorAcumulado: double.parse(acumuladoController.text),
                  );
                }
                Navigator.pop(context);
                _carregarReservas();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAporte(Reserva reserva) {
    final aporteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aporte em: ${reserva.nomeMeta}'),
        content: TextField(
          controller: aporteController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quanto deseja guardar?'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                double valor = double.parse(aporteController.text);
                await _apiService.atualizarReserva(
                  id: reserva.id,
                  nomeMeta: reserva.nomeMeta,
                  valorMeta: reserva.valorMeta,
                  valorAcumulado: reserva.valorAcumulado + valor,
                );
                Navigator.pop(context);
                _carregarReservas();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao realizar aporte: $e')));
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(Reserva reserva) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Reserva'),
        content: Text('Deseja excluir a meta "${reserva.nomeMeta}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _apiService.excluirReserva(reserva.id);
                Navigator.pop(context);
                _carregarReservas();
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
        title: Text('Reservas e Metas',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(onPressed: _carregarReservas, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarReservas,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Guardado',
                              style: TextStyle(color: Colors.white70, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(_formatarMoeda(_totalGuardado),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Minhas Metas',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16),
                    if (_reservas.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("Você ainda não criou nenhuma meta."),
                        ),
                      )
                    else
                      ..._reservas.map((reserva) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildReservaCard(context, reserva),
                          )),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        onPressed: () => _mostrarDialogoReserva(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReservaCard(BuildContext context, Reserva reserva) {
    double progresso = reserva.calcularProgresso();
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Meta'),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarDialogoReserva(reserva: reserva);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir Meta', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmarExclusao(reserva);
                },
              ),
            ],
          ),
        );
      },
      child: Container(
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
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.savings,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reserva.nomeMeta,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 4),
                      Text(
                          '${_formatarMoeda(reserva.valorAcumulado)} de ${_formatarMoeda(reserva.valorMeta)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary, size: 30),
                  onPressed: () => _mostrarDialogoAporte(reserva),
                )
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progresso,
                    backgroundColor:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    color: Theme.of(context).colorScheme.primary,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(progresso * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
