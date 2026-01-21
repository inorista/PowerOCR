import '../../domain/repositories/example_repository.dart';
import '../datasources/example_local_data_source.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleLocalDataSource localDataSource;

  ExampleRepositoryImpl(this.localDataSource);

  @override
  Future<List<String>> getExamples() async {
    return await localDataSource.getCachedExamples();
  }
}
