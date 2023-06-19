class Apis {
  static String base_url = 'https://ekyc.profitmart.in:46036/notificationadmin/';

  // getNewsApi(){
  //   return '${base_url}getScripWiseNews?isin=INE208A01029';
  // }
  getVersion(String data){
    return '${base_url}notificationShow?$data';
  }
}