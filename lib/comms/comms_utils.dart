enum CommunicationEvent {
  /// triggered when a connection is made, args include the other user's id
  onConnect,

  /// triggered when a connection is broken, args include the other user's id
  onDisconnect,

  /// triggered when a new connection is made, args include your user id
  onJoin,

  /// triggered when an application defined message has been received
  /// sends a dynamic in the form { "origin": String, "message": String}
  onMessageReceived,
}

class EventListener {
  final _listeners = Set<Function(dynamic)>();

  void clear() => _listeners.clear();

  void subscribe(Function(dynamic) listener) => _listeners.add(listener);

  void unsubscribe(Function(dynamic) listener) => _listeners.remove(listener);

  void fire(dynamic data) => _listeners.forEach((listener) => listener(data));
}
