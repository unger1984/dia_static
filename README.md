The middleware for [Dia](https://github.com/unger1984/dia) for serving static files.

## Usage:

A simple usage example:

```dart
import 'package:dia/dia.dart';
import 'package:dia_static/dia_static.dart';

void main() {
  final app = App();

  /// Serve files from example folder
  app.use(serve('./example'));

  app.use((ctx, next) async {
    ctx.body ??= 'error';
  });

  /// Start server listen on localhost:8080
  app
      .listen('localhost', 8080)
      .then((info) => print('Server started on http://localhost:8080'));
}
```

## Params:

* `root` - path to webserver root directory
* `prefix` - url mast start with `prefix` value

## Use with:

* [dia](https://github.com/unger1984/dia) - A simple dart http server in Koa2 style.
* [dia_router](https://github.com/unger1984/dia_router) - Middleware like as koa_router.
* [dia_body](https://github.com/unger1984/dia_body) - Package with the middleware for parse request body.
* [dia_cors](https://github.com/unger1984/dia_cors) - Package for CORS middleware.

## Features and bugs:

I will be glad for any help and feedback!
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/unger1984/dia_static/issues
