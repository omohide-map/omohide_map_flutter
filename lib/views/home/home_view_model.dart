import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/repositories/api/sample.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  HomeViewModel() {
    fetchData();
  }

  String? _data;

  String? get data => _data;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchData() async {
    final repository = SampleApiRepository();
    _data = await repository.fetchData();
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> getHealthCheck() async {
    final repository = SampleApiRepository();
    _data = await repository.getHealthCheck();
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
