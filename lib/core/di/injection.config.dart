// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories/atendimento_repository_imp.dart' as _i231;
import '../../domain/repositories/atendimento_repository.dart' as _i965;
import '../../domain/usecases/buscar_todos_atendimentos_usecase.dart' as _i392;
import '../../domain/usecases/excluir_atendimento_usecase.dart' as _i962;
import '../../domain/usecases/salvar_atendimento_usecase.dart' as _i534;
import '../../presentation/cubits/listagem/listagem_atendimento_cubit.dart'
    as _i256;
import '../../presentation/cubits/realizacao/realizacao_atendimento_cubit.dart'
    as _i411;
import '../database/database_helper.dart' as _i64;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i64.DatabaseHelper>(() => _i64.DatabaseHelper());
  gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
  gh.lazySingleton<_i965.AtendimentoRepository>(
    () => _i231.AtendimentoRepositoryImp(gh<_i64.DatabaseHelper>()),
  );
  gh.lazySingleton<_i392.BuscarTodosAtendimentosUseCase>(
    () =>
        _i392.BuscarTodosAtendimentosUseCase(gh<_i965.AtendimentoRepository>()),
  );
  gh.lazySingleton<_i962.ExcluirAtendimentoUseCase>(
    () => _i962.ExcluirAtendimentoUseCase(gh<_i965.AtendimentoRepository>()),
  );
  gh.lazySingleton<_i534.SalvarAtendimentoUseCase>(
    () => _i534.SalvarAtendimentoUseCase(gh<_i965.AtendimentoRepository>()),
  );
  gh.factory<_i411.RealizacaoAtendimentoCubit>(
    () => _i411.RealizacaoAtendimentoCubit(
      gh<_i965.AtendimentoRepository>(),
      gh<_i534.SalvarAtendimentoUseCase>(),
      gh<_i183.ImagePicker>(),
    ),
  );
  gh.factory<_i256.ListagemAtendimentoCubit>(
    () => _i256.ListagemAtendimentoCubit(
      gh<_i392.BuscarTodosAtendimentosUseCase>(),
      gh<_i962.ExcluirAtendimentoUseCase>(),
      gh<_i534.SalvarAtendimentoUseCase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
