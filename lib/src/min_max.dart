class MinMax {
  MinMax({required this.type, required this.columnName, this.label});
  final String columnName;
  final String? label;
  final MinMaxType type;

  String get query{
    return '${type.label}("$columnName") ${label == null ? "" : "AS $label"}';
  }
}


class Min extends MinMax{
  Min(String columnName, {String? label}):super(type: MinMaxType.min, columnName: columnName, label: label);
}

class Max extends MinMax{
  Max(String columnName, {String? label}):super(type: MinMaxType.max, columnName: columnName, label: label);
}

enum MinMaxType{
  min('MIN'), max('MAX');

  final String label;
  const MinMaxType(this.label);
}