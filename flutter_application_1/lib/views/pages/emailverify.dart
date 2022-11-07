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
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/verify.json", width: 150),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Congratulation! Your email has been verified.",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ));
  }
}
