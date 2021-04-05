library dia_static;

import 'dart:io';
import 'dart:math' as math;

import 'package:convert/convert.dart';
import 'package:dia/dia.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

Middleware<T> serve<T extends Context>(String root) => (ctx, next) async {
      if (!Directory(root).existsSync()) {
        throw ArgumentError('Not found root directory="$root"');
      }
      var isFound = false;
      if (ctx.request.method.toLowerCase() == 'get') {
        final rootDir = Directory(root);
        final rootPath = rootDir.resolveSymbolicLinksSync();

        final requestPath =
            path.joinAll([rootPath, ...ctx.request.uri.pathSegments]);
        final entityType = FileSystemEntity.typeSync(requestPath);

        if (entityType == FileSystemEntityType.file) {
          final file = File(requestPath);
          final resolvedPath = file.resolveSymbolicLinksSync();

          if (path.isWithin(rootPath, resolvedPath)) {
            isFound = true;

            final length = math.min(
                MimeTypeResolver().magicNumbersMaxLength, file.lengthSync());
            final byteSink = ByteAccumulatorSink();
            await file.openRead(0, length).listen(byteSink.add).asFuture();

            final contentType = MimeTypeResolver()
                    .lookup(file.path, headerBytes: byteSink.bytes) ??
                '';

            final stat = file.statSync();
            ctx.headers.set('Content-type', contentType);
            ctx.body = file.openRead();
          }
        }
      }
      if (!isFound) {
        ctx.throwError(404);
      }

      await next();
    };
