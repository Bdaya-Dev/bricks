import 'common.dart';
import 'get_it_config.config.dart';

const realEnv = Environment('real');
const testsEnv = Environment('tests');
const currentEnvironment = String.fromEnvironment('env');
String? getItEnvironment;

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'init', // default
  preferRelativeImports: false, // default
  asExtension: true, // default
  //to avoid warnings due to https://github.com/Milad-Akarie/injectable/issues/125
  ignoreUnregisteredTypesInPackages: ['my_app/common.dart'],
  externalPackageModulesBefore: [
    ExternalModule(BdayaFlutterCommonPackageModule),
  ],
)
void configureDependencies() => getIt.init(
      environment: getItEnvironment ?? currentEnvironment,
    );
