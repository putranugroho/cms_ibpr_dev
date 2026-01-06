class ConvertMpin {
  String digitToWord(String digit) {
    final units = [
      "nol",
      "satu",
      "dua",
      "tiga",
      "empat",
      "lima",
      "enam",
      "tujuh",
      "delapan",
      "sembilan"
    ];
    return units[int.parse(digit)];
  }

  String numberToWordsPerCharacter(String number) {
    // Tambahkan angka 0 di depan jika panjang number kurang dari 6
    while (number.length < 6) {
      number = '0' + number;
    }

    List<String> words = [];

    for (int i = 0; i < number.length; i++) {
      words.add(digitToWord(number[i]));
    }

    return words.join(" ");
  }
}
