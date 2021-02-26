class UUID {
  int _upper, _lower;

  UUID() {
    // TODO: implement this properly based on the documentation here
    // https://en.wikipedia.org/wiki/Universally_unique_identifier

    // dart doesn't have a 128 bit integer type by default
    // but int is 64 bits when not compiled to javascript
    // so if we ever compile to javascript we'll have to handle this differently
    _upper = 0;
    _lower = 0;
  }

  @override
  bool operator ==(other) =>
      other is UUID &&
      this._upper == other._upper &&
      this._lower == other._lower;
}

class UserInfo {}

class Message {}

class NetworkState {
  // Map<>
}
