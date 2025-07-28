import 'package:omohide_map_flutter/repositories/api.dart';

class SampleApiRepository {
  Future<String> fetchData() async {
    final response = await getApi('/');
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data');
    }
    return response.data;
  }
}
