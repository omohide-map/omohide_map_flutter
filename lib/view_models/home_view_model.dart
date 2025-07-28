import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/repositories/api/sample.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchData();
  }

  String? _data;

  String? get data => _data;

  Future<void> fetchData() async {
    final repository = SampleApiRepository();
    _data = await repository.fetchData();
    notifyListeners();
  }
}
