class Env {
  Env._privateConstructor({
    required this.ws,
  });

  final String ws;

  static Env? _instance;

  static Env get instance {
    if (_instance != null) return _instance!;
    _instance = Env._privateConstructor(
      ws: const String.fromEnvironment('WS'),
    );
    return _instance!;
  }
}
