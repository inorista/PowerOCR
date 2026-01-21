import 'example_local_data_source.dart';

class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
  @override
  Future<List<String>> getCachedExamples() async {
    return Future.value(['Cached Example 1', 'Cached Example 2']);
  }
}
