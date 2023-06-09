import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dimong/core/domain/dino.dart';
import '../data/repository.dart';

class MyPageUseCase extends ChangeNotifier {
  final MyPageRepository _repository = MyPageRepository();
  bool isLoading = false;
  final _dataController = StreamController<SendProfileResponse>.broadcast();
  Stream<SendProfileResponse> get dataStream => _dataController.stream;

  Future<void> loadData() async{
    isLoading = true;
    final data = await _repository.sendMyList();
    _dataController.sink.add(data);
    isLoading = false;
  }
  void dispose(){
    _dataController.close();
  }
}