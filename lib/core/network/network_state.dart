part of 'network_bloc.dart';

@immutable
abstract class NetworkState {}

class NetworkInitial extends NetworkState {}

class ConnectedState extends NetworkState {
  final String msg;

  ConnectedState(this.msg);
}

class NotConnectedState extends NetworkState {
  final String msg;

  NotConnectedState(this.msg);
}
