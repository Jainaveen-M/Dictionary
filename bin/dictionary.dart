void main(List<String> args) {
  print("1. before future function");
  Future.delayed(Duration(seconds: 5), () {
    print("future function");
  });
  Future.microtask(() => print("3.micro "));
  print("2.after future function");
}
