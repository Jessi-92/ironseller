import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';

import '../../app/config/app_config.dart';
import '../models/notificacion_cliente_model.dart';

class NotificacionesClienteService {
  static final NotificacionesClienteService _instance =
      NotificacionesClienteService._internal();

  factory NotificacionesClienteService() => _instance;

  NotificacionesClienteService._internal();

  HubConnection? _connection;
  int? _idLocalActual;

  final StreamController<NotificacionClienteModel> _controller =
      StreamController<NotificacionClienteModel>.broadcast();

  Stream<NotificacionClienteModel> get notificaciones => _controller.stream;

  bool get estaConectado =>
      _connection?.state == HubConnectionState.Connected;

  Future<void> conectar({required int idLocal}) async {
    if (_connection?.state == HubConnectionState.Connected &&
        _idLocalActual == idLocal) {
      return;
    }

    if (_connection?.state == HubConnectionState.Connected) {
      await desconectar();
    }

    final hubUrl = '${AppConfig.serverBaseUrl}/hubs/notificaciones';

    _connection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .build();

    _connection!.on('ClienteDetectado', (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final notificacion =
          NotificacionClienteModel.fromSignalR(arguments.first);

      _controller.add(notificacion);
    });

    await _connection!.start();

    await _connection!.invoke(
      'UnirseLocal',
      args: [idLocal],
    );

    _idLocalActual = idLocal;

    print('Conectado a SignalR en local_$idLocal');
  }

  Future<void> desconectar() async {
    if (_connection == null) return;

    final idLocal = _idLocalActual;

    if (_connection!.state == HubConnectionState.Connected && idLocal != null) {
      await _connection!.invoke(
        'SalirLocal',
        args: [idLocal],
      );
    }

    await _connection!.stop();

    _connection = null;
    _idLocalActual = null;
  }

  void dispose() {
    _controller.close();
  }
}