#!/bin/bash
# ════════════════════════════════════════════════════════
# 🧱 CLEAN ARCHITECTURE FEATURE GENERATOR (Flutter)
# ════════════════════════════════════════════════════════
# Uso:
#   ./scripts/create_feature_clean.sh auth
# Resultado:
#   Crea la estructura completa de carpetas y archivos base
#   con clases Dart prellenadas para la feature indicada.
# ════════════════════════════════════════════════════════

if [ -z "$1" ]; then
  echo "❌ Debes pasar el nombre de la feature. Ejemplo:"
  echo "   ./scripts/create_feature_clean.sh auth"
  exit 1
fi

FEATURE_NAME=$1
# ✅ Capitaliza la primera letra solo para clases
FEATURE_CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"
FEATURE_PATH="lib/features/$FEATURE_NAME"

echo "🚀 Creando feature '$FEATURE_NAME' en: $FEATURE_PATH"

# Crear estructura de carpetas
mkdir -p $FEATURE_PATH/{presentation/{pages,widgets,viewmodels},domain/{entities,repositories,usecases},data/{models,datasources,repositories_impl}}

# ╔══════════════════════════════════════════════════════╗
# ║                  PRESENTATION LAYER                  ║
# ╚══════════════════════════════════════════════════════╝

cat <<EOF > $FEATURE_PATH/presentation/pages/${FEATURE_NAME}_page.dart
import 'package:flutter/material.dart';
import '../viewmodels/${FEATURE_NAME}_viewmodel.dart';

class ${FEATURE_CLASS_NAME}Page extends StatelessWidget {
  const ${FEATURE_CLASS_NAME}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE_CLASS_NAME} Page')),
      body: const Center(
        child: Text('Welcome to ${FEATURE_CLASS_NAME} feature!'),
      ),
    );
  }
}
EOF

cat <<EOF > $FEATURE_PATH/presentation/viewmodels/${FEATURE_NAME}_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../domain/usecases/${FEATURE_NAME}_usecase.dart';

class ${FEATURE_CLASS_NAME}ViewModel extends ChangeNotifier {
  final ${FEATURE_CLASS_NAME}UseCase useCase;

  ${FEATURE_CLASS_NAME}ViewModel(this.useCase);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await useCase.execute();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
EOF

cat <<EOF > $FEATURE_PATH/presentation/widgets/${FEATURE_NAME}_widget.dart
import 'package:flutter/material.dart';

class ${FEATURE_CLASS_NAME}Widget extends StatelessWidget {
  const ${FEATURE_CLASS_NAME}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Custom widget for ${FEATURE_CLASS_NAME} feature'),
    );
  }
}
EOF

# ╔══════════════════════════════════════════════════════╗
# ║                    DOMAIN LAYER                      ║
# ╚══════════════════════════════════════════════════════╝

cat <<EOF > $FEATURE_PATH/domain/entities/${FEATURE_NAME}_entity.dart
class ${FEATURE_CLASS_NAME}Entity {
  final int id;
  final String name;

  ${FEATURE_CLASS_NAME}Entity({required this.id, required this.name});
}
EOF

cat <<EOF > $FEATURE_PATH/domain/repositories/${FEATURE_NAME}_repository.dart
import '../entities/${FEATURE_NAME}_entity.dart';

abstract class ${FEATURE_CLASS_NAME}Repository {
  Future<List<${FEATURE_CLASS_NAME}Entity>> fetchAll();
}
EOF

cat <<EOF > $FEATURE_PATH/domain/usecases/${FEATURE_NAME}_usecase.dart
import '../repositories/${FEATURE_NAME}_repository.dart';

class ${FEATURE_CLASS_NAME}UseCase {
  final ${FEATURE_CLASS_NAME}Repository repository;

  ${FEATURE_CLASS_NAME}UseCase(this.repository);

  Future<void> execute() async {
    final data = await repository.fetchAll();
    // TODO: manejar datos recibidos
  }
}
EOF

# ╔══════════════════════════════════════════════════════╗
# ║                      DATA LAYER                      ║
# ╚══════════════════════════════════════════════════════╝

cat <<EOF > $FEATURE_PATH/data/models/${FEATURE_NAME}_model.dart
import '../../domain/entities/${FEATURE_NAME}_entity.dart';

class ${FEATURE_CLASS_NAME}Model extends ${FEATURE_CLASS_NAME}Entity {
  ${FEATURE_CLASS_NAME}Model({required super.id, required super.name});

  factory ${FEATURE_CLASS_NAME}Model.fromJson(Map<String, dynamic> json) =>
      ${FEATURE_CLASS_NAME}Model(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
EOF

cat <<EOF > $FEATURE_PATH/data/datasources/${FEATURE_NAME}_remote_datasource.dart
import '../models/${FEATURE_NAME}_model.dart';

abstract class ${FEATURE_CLASS_NAME}RemoteDataSource {
  Future<List<${FEATURE_CLASS_NAME}Model>> fetchAll();
}

class ${FEATURE_CLASS_NAME}RemoteDataSourceImpl implements ${FEATURE_CLASS_NAME}RemoteDataSource {
  @override
  Future<List<${FEATURE_CLASS_NAME}Model>> fetchAll() async {
    // TODO: implementar llamada a API o datasource remoto
    return [];
  }
}
EOF

cat <<EOF > $FEATURE_PATH/data/repositories_impl/${FEATURE_NAME}_repository_impl.dart
import '../../domain/repositories/${FEATURE_NAME}_repository.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../datasources/${FEATURE_NAME}_remote_datasource.dart';

class ${FEATURE_CLASS_NAME}RepositoryImpl implements ${FEATURE_CLASS_NAME}Repository {
  final ${FEATURE_CLASS_NAME}RemoteDataSource remoteDataSource;

  ${FEATURE_CLASS_NAME}RepositoryImpl(this.remoteDataSource);

  @override
  Future<List<${FEATURE_CLASS_NAME}Entity>> fetchAll() async {
    final models = await remoteDataSource.fetchAll();
    return models;
  }
}
EOF

echo "✅ Feature '$FEATURE_NAME' creada exitosamente."
echo "📂 Revisa: $FEATURE_PATH"
