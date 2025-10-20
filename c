#!/bin/bash
# Usage: ./scripts/create_clean_base.sh
echo "🚀 Generating Clean Architecture base structure for Flutter"

# === Core/Shared Layer ===
mkdir -p lib/core/{errors,utils,theme}
touch lib/core/constants.dart

mkdir -p lib/shared/{widgets,styles,extensions}
echo "// Shared widgets go here" > lib/shared/widgets/README.md

# === Features Root ===
mkdir -p lib/features

# Create a sample feature folder
FEATURE="example"
mkdir -p lib/features/$FEATURE/{presentation,domain,data}

# Presentation
mkdir -p lib/features/$FEATURE/presentation/{pages,widgets,viewmodels}
touch lib/features/$FEATURE/presentation/pages/${FEATURE}_page.dart
echo "import 'package:flutter/material.dart';\n\nclass ${FEATURE^}Page extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(body: Center(child: Text('$FEATURE page')));\n  }\n}" > lib/features/$FEATURE/presentation/pages/${FEATURE}_page.dart

# Domain
mkdir -p lib/features/$FEATURE/domain/{entities,usecases,repositories}
touch lib/features/$FEATURE/domain/entities/${FEATURE}_entity.dart
echo "class ${FEATURE^}Entity {\n  // TODO: define entity\n}" > lib/features/$FEATURE/domain/entities/${FEATURE}_entity.dart

touch lib/features/$FEATURE/domain/repositories/${FEATURE}_repository.dart
echo "abstract class ${FEATURE^}Repository {\n  // TODO: define interface\n}" > lib/features/$FEATURE/domain/repositories/${FEATURE}_repository.dart

touch lib/features/$FEATURE/domain/usecases/${FEATURE}_usecase.dart
echo "class ${FEATURE^}UseCase {\n  // TODO: implement use case\n}" > lib/features/$FEATURE/domain/usecases/${FEATURE}_usecase.dart

# Data
mkdir -p lib/features/$FEATURE/data/{datasources,models,repositories_impl}
touch lib/features/$FEATURE/data/models/${FEATURE}_model.dart
echo "class ${FEATURE^}Model {\n  // TODO: define model\n}" > lib/features/$FEATURE/data/models/${FEATURE}_model.dart

touch lib/features/$FEATURE/data/datasources/${FEATURE}_datasource.dart
echo "abstract class ${FEATURE^}DataSource {\n  // TODO\n}" > lib/features/$FEATURE/data/datasources/${FEATURE}_datasource.dart

touch lib/features/$FEATURE/data/repositories_impl/${FEATURE}_repository_impl.dart
echo "import '../../domain/repositories/${FEATURE}_repository.dart';\n\nclass ${FEATURE^}RepositoryImpl implements ${FEATURE^}Repository {\n  // TODO: implement\n}" > lib/features/$FEATURE/data/repositories_impl/${FEATURE}_repository_impl.dart

echo "✅ Base structure created. Feature '$FEATURE' scaffolded."

