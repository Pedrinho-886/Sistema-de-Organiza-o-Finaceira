import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/animated_fade_in.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Dashboard Analítico', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedFadeIn(
              child: Text(
                'Visão Geral de Despesas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedFadeIn(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Acompanhe seus gastos por categoria neste mês.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ),
            const SizedBox(height: 32),

            // Card do Gráfico (Glassmorphism)
            AnimatedFadeIn(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: SizedBox(
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
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            // Legendas Animadas
            AnimatedFadeIn(
              delay: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  _buildLegendItem(AppTheme.primary, 'Moradia', 'R\$ 1.200,00', 40),
                  const SizedBox(height: 12),
                  _buildLegendItem(AppTheme.accent, 'Alimentação', 'R\$ 900,00', 30),
                  const SizedBox(height: 12),
                  _buildLegendItem(AppTheme.secondary, 'Transporte', 'R\$ 600,00', 20),
                  const SizedBox(height: 12),
                  _buildLegendItem(Colors.grey.shade600, 'Lazer', 'R\$ 300,00', 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppTheme.primary,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 1:
          return PieChartSectionData(
            color: AppTheme.accent,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 2:
          return PieChartSectionData(
            color: AppTheme.secondary,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.grey.shade600,
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _buildLegendItem(Color color, String category, String value, int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.circle, color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                Text('$percentage%', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
              ],
            ),
          ),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}
