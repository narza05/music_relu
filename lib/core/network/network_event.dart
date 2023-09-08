part of 'network_bloc.dart';

@immutable
abstract class NetworkEvent {}

class ConnectedEvent extends NetworkEvent {}

class NotConnectedEvent extends NetworkEvent {}
