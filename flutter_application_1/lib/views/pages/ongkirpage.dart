part of 'pages.dart';

//fstl
class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String dropdownvalue = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hitung Ongkir"),
        
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                //Untuk form
                Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              DropdownButton(
                                  value: dropdownvalue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                                  SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: ctrlBerat,
                                      decoration: InputDecoration(
                                        labelText: 'Berat (gr)',
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value){
                                        return value == null || value == 0 ? 'Berat harus diisi atau tidak boleh 0!' : null;
                                      },
                                    ),
                                  )
                            ],
                          ),
                        )
                      ],
                    )),

                //Untuk nampilin data
                Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
          isLoading == true ? uiloading.loading() : Container(),
        ],
      ),
    );
  }
}
