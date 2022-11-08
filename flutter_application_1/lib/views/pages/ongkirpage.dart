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

  //Tambahan
  dynamic provId;
  dynamic provinceData;
  dynamic selectedProvince;

  Future<List<Province>> getProvince() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic cityId;
  dynamic cityData;
  dynamic selectedCity;

  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provinceData = getProvince();
  }

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
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  decoration: const InputDecoration(
                                    labelText: 'Berat (gr)',
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value == null || value == 0
                                        ? 'Berat harus diisi atau tidak boleh 0!'
                                        : null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Origin",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 210,
                                child: FutureBuilder(
                                    future: provinceData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButton(
                                            isExpanded: true,
                                            value: selectedProvince,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 16,
                                            style:
                                                TextStyle(color: Colors.black),
                                            hint: selectedProvince == null
                                                ? Text("Pilih provinsi")
                                                : Text(
                                                    selectedProvince.provinsi),
                                            items: snapshot.data!.map<
                                                    DropdownMenuItem<Province>>(
                                                (Province value) {
                                              return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value.province
                                                      .toString()));
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProvince = newValue;
                                                provId =
                                                    selectedProvince.provinceId;
                                              });
                                              selectedCity = null;
                                              cityData = getCities(provId);
                                            });
                                      } else if (snapshot.hasError) {
                                        return const Text("Tidak ada data");
                                      }
                                      return uiloading.loadingDD();
                                    }),
                              )
                            ],
                          ),
                        ),
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
