// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/helper/file_system_helper.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class BlockChildrenSelection extends UseCase<List<String>, String> {
  FileSystemRepository repository;
  BlockChildrenSelection({
    required this.repository,
  });
  @override
  Future<Either<Failure, List<String>>> call(String parentId) {
    return repository.getRelations(parentId);
  }
}
