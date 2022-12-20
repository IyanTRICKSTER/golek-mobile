import 'dart:developer';

import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatProvider {
  final StreamChatClient streamChatClient;
  static final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();

  static StreamChatProvider? _instance;

  static StreamChatProvider get instance {
    if (_instance != null) {
      return _instance!;
    }

    _instance = StreamChatProvider(
      streamChatClient: StreamChatClient(
        'f89c8b7p9jz9',
        logLevel: Level.INFO,
      ),
    );

    return _instance!;
  }

  StreamChatClient get client => streamChatClient;

  static void dispose() {
    // log("disposing instance of streamchat provider");
    _instance = null;
  }

  StreamChatProvider({required this.streamChatClient});

  Future<void> connectUser() async {
    // log(_sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID).toString());
    streamChatClient.connectUser(
        User(
          id: _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID).toString(),
          name: _sharedPreferencesManager.getString(SharedPreferencesManager.keyUsername),
        ),
        streamChatClient
            .devToken(
              _sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID).toString(),
            )
            .rawValue);
  }

  Channel setupChannel(List<String> members) {
    return streamChatClient.channel(
      "messaging",
      extraData: {
        "members": members..add(_sharedPreferencesManager.getInt(SharedPreferencesManager.keyUserID).toString()),
      },
    );
  }
}
