
main() {
  
  for(int i = 0; i< 100; i ++){
    print( (DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch / (86400 * 1000)).round()  );
  }
}