part of 'services.dart';

class EmailService {
  Future<http.Response> sendmail(email) {
    return http.post(
      Uri.https(Const.smtpUrl,
          "/cirestapi/cirestapi/index.php/api/mahasiswa/sendmail"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AFL-API-KEY':'AFL-CloudComp'
      },
      body: jsonEncode(<String, dynamic>{'email': email}),
    );
  }
}
