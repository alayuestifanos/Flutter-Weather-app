import 'dart:io';

void main(){
  perfomTasks();

}
void perfomTasks() async{
    task1();
    String task2Result = await task2();
    task3(task2Result);
}
void task1(){
  print("Task 1 complete");
}
Future task2() async{
  Duration threeSeconds = Duration(seconds: 3);
  String result ='';
  await Future.delayed(threeSeconds,(){
    result =  "Task 2 is completed";
    print(result);
  });
  return result;

}
void task3(String task2Data){
  print("Task 3 complete with task2 data $task2Data");
}