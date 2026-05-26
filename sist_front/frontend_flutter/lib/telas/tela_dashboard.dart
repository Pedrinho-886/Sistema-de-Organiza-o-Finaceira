import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../servicos/servico_api.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final int usuarioId;
  const DashboardScreen({super.key, required this.usuarioId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  int touchedIndex = -1;
  Map<String, double> _gastosPorCategoria = {};
  double _totalGastos = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      final todasTransacoes = await _apiService.listarTodasTransacoes(widget.usuarioId);
      
      // Filtrar apenas despesas do mês atual
      final agora = DateTime.now();
      final despesasMes = todasTransacoes.where((t) {
        final data = DateTime.parse(t['data']);
        return t['tipo'].toString().toLowerCase() == 'despesa' &&
               data.month == agora.month &&
               data.year == agora.year;
      }).toList();

      Map<String, double> agrupado = {};
      double total = 0;

      for (var d in despesasMes) {
        String cat = d['categoria'] ?? 'Outros';
        double valor = double.parse(d['valor'].toString());
        agrupado[cat] = (agrupado[cat] ?? 0) + valor;
        total += valor;
      }

      setState(() {
        _gastosPorCategoria = agrupado;
        _totalGastos = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar gráficos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Análise de Gastos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarDados),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _totalGastos == 0
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Distribuição por Categoria',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      _buildChart(),
                      const SizedBox(height: 32),
                      _buildLegend(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pie_chart_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Sem despesas registradas este mês.', style: TextStyle(color: Colors.grey)),
          TextButton(onPressed: _carregarDados, child: const Text('Atualizar')),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 250,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sectionsSpace: 4,
          centerSpaceRadius: 60,
          sections: _getSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    int i = 0;
    return _gastosPorCategoria.entries.map((entry) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = _getColor(i++);
      final percent = (entry.value / _totalGastos) * 100;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percent.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    int i = 0;
    return Column(
      children: _gastosPorCategoria.entries.map((entry) {
        final color = _getColor(i++);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: Row(
            children: [
              Container(width: 16, height: 16, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold))),
              Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(entry.value)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.redAccent,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}
