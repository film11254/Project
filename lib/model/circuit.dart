class Circuit {
  String title = '';
  String subtitle = '';
  int ampLimit = 0;
  int voltLimit = 0;
  int wattLimit = 0;
  String dateReset = '';
  Object device = {};
  int status = 0;
  
  Circuit(
      {required this.title,
      required this.ampLimit,
      required this.dateReset,
      required this.voltLimit,
      required this.wattLimit,
      required this.subtitle,
      required this.status});
}
