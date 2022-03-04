import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:music_app/constants.dart';
import 'package:music_app/screens/child_play.dart';

class RMPlayer with ChangeNotifier{
  double _position = 0;
  double get position=>_position;
  int _total = 0;
  int _current = 0;
  String _status = 'none';
  double ? _seeking;

  int get total=>_total;
  int get current=>_current;
  double? get seeking=>_seeking;
  String get status=>_status;

  double Setposition(double val){
    print("Set position fenction called");
    _position=val;
  notifyListeners();
  return _position;
  }

  double? SetSeeking(var val){
    _seeking=val;
    notifyListeners();
    return _seeking;
  }

  int SetTotal(int val){
    _total=val;
    notifyListeners();
    return _total;
  }

  int SetCurrent(int val){
    _current=val;
    notifyListeners();
    return _current;
  }
  String SetStatus(String val){
    _status=val;
    notifyListeners();
    return _status;
  }



}
