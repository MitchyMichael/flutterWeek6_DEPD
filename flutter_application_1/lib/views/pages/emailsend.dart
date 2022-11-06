part of 'pages.dart';

class Emailsend extends StatefulWidget {
  const Emailsend({ Key? key }) : super(key: key);

  @override
  _EmailsendState createState() => _EmailsendState();
}

class _EmailsendState extends State<Emailsend> {
  final _loginKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    ctrlEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Email"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _loginKey,
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email", prefixIcon: Icon(Icons.email)),
                controller: ctrlEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return !EmailValidator.validate(value.toString())
                      ? 'Email tidak valid!'
                      : null;
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_loginKey.currentState!.validate()) {
            await EmailService()
                .sendmail(ctrlEmail.text.toString())
                .then((value) {
              var result = json.decode(value.body);
              print(result.toString());

              Fluttertoast.showToast(
                msg: (result['message'] == null 
                  ? result['error'] 
                  : result['message']),
                toastLength: Toast.LENGTH_SHORT,
                
              );
              
            });
          } else {
            Fluttertoast.showToast(
              msg: "Gagal",
              toastLength: Toast.LENGTH_SHORT,
            );
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}