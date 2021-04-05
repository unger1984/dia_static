library dia_static;

import 'dart:io';
import 'dart:math' as math;

import 'package:convert/convert.dart';
import 'package:dia/dia.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

/// Middleware for serving static path [root]
/// all requested url try found file in [root]
Middleware<T> serve<T extends Context>(String root) => (ctx, next) async {
      if (!Directory(root).existsSync()) {
        throw ArgumentError('Not found root directory="$root"');
      }
      var isFound = false;
      if (ctx.request.method.toLowerCase() == 'get' ||
          ctx.request.method.toLowerCase() == 'header') {
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
            ctx.headers.set('Content-length', stat.size.toString());
            ctx.headers.set('Content-type', contentType);
            ctx.statusCode =
                ctx.request.method.toLowerCase() == 'header' ? 204 : 200;
            ctx.body = ctx.request.method.toLowerCase() == 'header'
                ? ''
                : file.openRead();
          }
        }
      }
      // TODO set not found if not other routes
      // if (!isFound) {
      //   ctx.throwError(404);
      // }

      await next();
    };
