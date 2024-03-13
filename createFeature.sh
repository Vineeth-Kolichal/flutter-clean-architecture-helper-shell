
#Edit feature name , feature name should be in lower case letters
feature_name="authentication"
capitalized_feature_name=$(echo "$feature_name" | perl -nE 'say ucfirst')
echo "$capitalized_feature_name"
cd lib
cd features
mkdir "$feature_name"
cd "$feature_name"
mkdir data
cd data
mkdir data_sources
cd data_sources
touch "${feature_name}_datasources.dart"
echo "
abstract class ${capitalized_feature_name}DataSource{}
class ${capitalized_feature_name}DataSourceImpl implements ${capitalized_feature_name}DataSource{} 
" >"${feature_name}_datasources.dart"
cd ..
mkdir models
cd models
touch .gitkeep
cd ..
mkdir repository
cd repository
touch "${feature_name}_repo_impl.dart"
echo "
import '../../domain/repository/${feature_name}_repository.dart';

class ${capitalized_feature_name}RepoImpl implements ${capitalized_feature_name}Repository{

} " >"${feature_name}_repo_impl.dart"
cd ..
cd ..
mkdir domain
cd domain
mkdir repository
cd repository
touch "${feature_name}_repository.dart"
echo "
abstract class ${capitalized_feature_name}Repository{

} " >"${feature_name}_repository.dart"
cd ..
mkdir usecases
cd usecases
touch .gitkeep
cd ..
mkdir entities
cd entities
touch .gitkeep
cd ..
cd ..
mkdir presentation
cd presentation
mkdir blocs
cd blocs
touch .gitkeep
cd ..
mkdir pages
cd pages
touch "${feature_name}_screen.dart"
echo "
import 'package:flutter/material.dart';

class ${capitalized_feature_name}Screen extends StatelessWidget {
  const ${capitalized_feature_name}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
" > "${feature_name}_screen.dart"
cd ..
mkdir widgets
cd widgets
touch .gitkeep
