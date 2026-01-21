import '../repositories/example_repository.dart';

class GetExamples {
  final ExampleRepository repository;

  GetExamples(this.repository);

  Future<List<String>> call() async {
    return await repository.getExamples();
  }
}
