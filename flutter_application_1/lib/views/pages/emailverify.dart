part of "pages.dart";

class Emailverify extends StatefulWidget {
  const Emailverify({Key? key}) : super(key: key);

  @override
  _EmailverifyState createState() => _EmailverifyState();
}

class _EmailverifyState extends State<Emailverify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Done"),
      ),
      body: const Center(
        child: Text ("Congratulation! Your email has been verified!"),
      ),
    );
  }
}
