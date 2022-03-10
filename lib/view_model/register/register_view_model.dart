import 'package:flutter/material.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  TabController? _tabController;
  int _curIndex = 0;

  int get curIndex => _curIndex;

  set tabController(TabController tabController)  => _tabController = tabController..addListener(_tabControllerListener);
  TabController get tabController => _tabController!;

  void moveToNextStep() {

    int currentIndex = _tabController!.index;
    if(currentIndex+1 >= _tabController!.length){
      return;
    }
    tabController.animateTo(currentIndex += 1);
  }

  void moveToPreviousStep(){

    int currentIndex = _tabController!.index;
    if(currentIndex - 1 < 0){
      return;
    }
    tabController.animateTo(currentIndex -= 1);

  }

  void _tabControllerListener(){
    _curIndex = _tabController!.index;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.removeListener(_tabControllerListener);
  }



}