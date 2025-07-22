class EcgSample {
  final int value; // 16-bit signed integer (raw or millivolts)
  final DateTime timestamp;

  EcgSample({required this.value, required this.timestamp});
}

class EcgSampleBuffer {
  final int maxLength;
  final List<EcgSample> _samples = [];

  EcgSampleBuffer({this.maxLength = 4096});

  void addSample(EcgSample sample) {
    _samples.add(sample);
    if (_samples.length > maxLength) {
      _samples.removeAt(0);
    }
  }

  List<EcgSample> get samples => List.unmodifiable(_samples);

  void clear() => _samples.clear();
}
