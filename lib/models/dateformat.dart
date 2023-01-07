class DateFormat {
  String _dateformat = "";

  String get dateformat => _dateformat;

  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const List<String> _weeks = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  DateFormat.fromDatetime(DateTime datetime) {
    _dateformat =
        "${datetime.day} ${_months[datetime.month - 1]} ${_weeks[datetime.weekday - 1]} ${datetime.year}";
  }
}
