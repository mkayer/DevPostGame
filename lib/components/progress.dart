import 'package:shared_preferences/shared_preferences.dart';

class Progress {

  //does it need this initializer?
  //Progress() : cardsUnlocked=[], battlesCompleted=[], hpLevel=0, dialoguesCompleted=[];

  //cards
  final List<int> cardsUnlocked = [3,4];

  //level
  final List<String> battlesCompleted = [];

  //hp amt
  int hpLevel = 20;

  //Dialogue
  final List<String> dialoguesCompleted = [];
  
  //----------------------------------------------------------------
  //------------------------------methods to update each progress----------------------------------
  //----------------------------------------------------------------
  
  ///local save. Use saveCardProgress() for pushing local copy to shared prefs
  ///or use saveAllProgress()
  void updateCardProgress(List<int> newcardindexes) async{
    cardsUnlocked.addAll(newcardindexes);
  }

  ///local save. Use saveBattleProgress() for pushing local copy to shared prefs
  ///or use saveAllProgress()
  void updateBattleProgress(List<String> newbattlenames) async{
    battlesCompleted.addAll(newbattlenames);
  }

  ///local save. Use saveHpProgress() for pushing local copy to shared prefs
  ///or use saveAllProgress()
  void updateHpProgress(int newHP) async{
    hpLevel = newHP;
  }

  ///local save. Use saveDialogueProgress() for pushing local copy to shared prefs
  ///or use saveAllProgress()
  void updateDialogueProgress(List<String> newscenenames) async{
    dialoguesCompleted.addAll(newscenenames);
  }

  //----------------------------------------------------------------
  //------------------------methods to push each progress to sharedprefs-----------
  //----------------------------------------------------------------
  
  void saveCardProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardsToPush = [];
    for (var element in cardsUnlocked) {
      String strelmt = element.toString();
      cardsToPush.add(strelmt);
    } 
    await prefs.setStringList('cardsUnlocked', cardsToPush);
  }

  void saveBattleProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('battlesCompleted', battlesCompleted);
  }

  void saveHpProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hpLevel', hpLevel);
  }

  void saveDialogueProgress() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dialoguesCompleted', dialoguesCompleted);
  }

  void saveAllProgress() async {
    saveCardProgress();
    saveBattleProgress();
    saveHpProgress();
    saveDialogueProgress();
  }

  //----------------------------------------------------------------
  //----------------------methods to fetch each progress from sharedprefs-----------
  //----------------------------------------------------------------
  
  void fetchCardProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? cardsList = prefs.getStringList('cardsUnlocked');
    cardsList?.forEach((element) {
      int elemint= int.parse(element);
      if (cardsUnlocked.contains(elemint)) {
        return;
      } else {
      cardsUnlocked.add(elemint);
      }
     });
  }

  void fetchBattleProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? battlesList = prefs.getStringList('battlesCompleted');
    battlesList?.forEach((element) {
      if (battlesCompleted.contains(element)) {
        return;
      } else {
      battlesCompleted.add(element);
      }
     });
  }

  void fetchHpProgress() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? hpvalue = prefs.getInt('hpLevel');
    bool checking = hpvalue.toString()!='null'?true:false;
    if(checking){
      //String testing=' in progress.dart, delete this if hpvalue isnt null';
      //print(hpvalue.toString() + testing);
      //if checking is true then hpvalue exists
      if (hpLevel != hpvalue){
        hpLevel = hpvalue!;
      }
    }
  }

  void fetchDialogueProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? dialoguesList = prefs.getStringList('dialoguesCompleted');
    dialoguesList?.forEach((element) {
      if (dialoguesCompleted.contains(element)) {
        return;
      } else {
      dialoguesCompleted.add(element);
      }
     });
  }

  void fetchAllProgress() async {
    //calls all above methods
    fetchCardProgress();
    fetchBattleProgress();
    fetchHpProgress();
    fetchDialogueProgress();
  }  

}