import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/ecg_sample.dart';

class EcgWaveformChart extends StatelessWidget {
  final List<EcgSample> samples;
  final int maxSamples;
  final Color lineColor;
  final Color anomalyColor;
  final int anomalyThreshold;
  final void Function(int index, EcgSample sample)? onAnomalyDetected;

  const EcgWaveformChart({
    super.key,
    required this.samples,
    this.maxSamples = 512,
    this.lineColor = Colors.red,
    this.anomalyColor = Colors.orange,
    this.anomalyThreshold = 2000,
    this.onAnomalyDetected,
  });

  @override
  Widget build(BuildContext context) {
    final visibleSamples =
        samples.length > maxSamples
            ? samples.sublist(samples.length - maxSamples)
            : samples;
    final List<FlSpot> normalSpots = [];
    final List<FlSpot> anomalySpots = [];
    for (int i = 0; i < visibleSamples.length; i++) {
      final value = visibleSamples[i].value;
      final spot = FlSpot(i.toDouble(), value.toDouble());
      if (value.abs() > anomalyThreshold) {
        anomalySpots.add(spot);
        if (onAnomalyDetected != null) {
          onAnomalyDetected!(i, visibleSamples[i]);
        }
      } else {
        normalSpots.add(spot);
      }
    }
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: normalSpots,
              isCurved: false,
              color: lineColor,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            if (anomalySpots.isNotEmpty)
              LineChartBarData(
                spots: anomalySpots,
                isCurved: false,
                color: anomalyColor,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
          ],
          minY:
              visibleSamples.isNotEmpty
                  ? visibleSamples
                          .map((e) => e.value)
                          .reduce((a, b) => a < b ? a : b)
                          .toDouble() -
                      100
                  : 0,
          maxY:
              visibleSamples.isNotEmpty
                  ? visibleSamples
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() +
                      100
                  : 1000,
        ),
      ),
    );
  }
}
