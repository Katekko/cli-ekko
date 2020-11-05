import 'package:ekko_cli/commands/create/create.dart';
import 'package:ekko_cli/commands/create/endpoint/samples/body_dto.dart';
import 'package:ekko_cli/common/utils/logger/logger.dart';
import 'package:ekko_cli/core/command.dart';
import 'package:ekko_cli/core/functions/add_export.dart';
import 'package:recase/recase.dart';

import '../../../ekko_cli.dart';
import 'samples/controller.dart';
import 'samples/response_dto.dart';
import 'samples/endpoint.dart';

class CreateEndpointCommand extends Command with CreateMixin {
  @override
  Future<void> execute() async {
    var split = EkkoCli.arguments[1].split(':');
    var hasEndpointName = split.length == 2;
    if (hasEndpointName) {
      var baseFolderPresentation =
          'lib/presentation/endpoints/${name.snakeCase}';

      var controllerBindingName = '${name.pascalCase}ControllerBinding';

      var screenDir = '$baseFolderPresentation/${name.snakeCase}.endpoint.dart';
      var controllerDir =
          '$baseFolderPresentation/${name.snakeCase}.controller.dart';
      var controllerBindingDir =
          'lib/infrastructure/navigation/bindings/controllers/${name.snakeCase}.controller.binding.dart';

      var dtoResponseDir =
          '$baseFolderPresentation/dto/${name.snakeCase}.response.dart';
      var dtoBodyDir =
          '$baseFolderPresentation/dto/${name.snakeCase}.body.dart';

      await EndpointSample(
        screenDir: '$screenDir',
        controllerImport: './controllers/${name.snakeCase}.controller.dart',
        name: name,
      ).create();

      await addExport(
        path: 'lib/presentation/endpoint.dart',
        line:
            'export \'./endpoints/${name.snakeCase}/${name.snakeCase}.endpoint.dart\';',
      );

      await ControllerSample(path: controllerDir, name: name).create();

      await ResponseDtoSample(
        path: dtoResponseDir,
        fileName: name,
      ).create();

      await BodyDtoSample(
        path: dtoBodyDir,
        fileName: name,
      ).create();

      // await addRoute(name);

      // await BindingSample(
      //   path: controllerBindingDir,
      //   bindingName: controllerBindingName,
      //   controllerName: controllerName,
      //   controllerImport:
      //       './../../../../presentation/${name.snakeCase}/controllers/${name.snakeCase}.controller.dart',
      // ).create();

      // await addExport(
      //   path:
      //       'lib/infrastructure/navigation/bindings/controllers/controllers_bindings.dart',
      //   line: '''export '${name.snakeCase}.controller.binding.dart';''',
      // );
    } else {
      LogService.error(
        'Declare a name for your screen: get create screen:"Name of your Screen"',
      );
    }
  }

  @override
  String get hint => 'Create a new screen with binding and routes';

  @override
  bool validate() => true;
}
