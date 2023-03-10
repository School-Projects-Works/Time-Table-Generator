// ignore_for_file: file_names

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String trimToLowerCase() => replaceAll(' ', '').toLowerCase();

  String getInitials() => trim()
      .split(RegExp(' +'))
      .map((s) => s[0])
      .take(5)
      .join()
      .replaceAll(' ', '')
      .toLowerCase();
}
