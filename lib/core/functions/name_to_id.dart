String convertStringToNumbers(String input) {
  // Define the mapping of alphabets to numbers
  final Map<String, String> alphabetToNumber = {
    'a': '1',
    'b': '2',
    'c': '3',
    'd': '4',
    'e': '5',
    'f': '6',
    'g': '7',
    'h': '8',
    'i': '9',
    'j': '10',
    'k': '11',
    'l': '12',
    'm': '13',
    'n': '14',
    'o': '15',
    'p': '16',
    'q': '17',
    'r': '18',
    's': '19',
    't': '20',
    'u': '21',
    'v': '22',
    'w': '23',
    'x': '24',
    'y': '25',
    'z': '26'
  };

  // Convert the input string to lowercase to handle both cases
  String lowerInput = input.toLowerCase().trim().replaceAll(' ', '');

  // Initialize an empty string to store the result
  String result = '';

  // Iterate through each character in the input string
  for (int i = 0; i < lowerInput.length; i++) {
    String char = lowerInput[i];

    // Check if the character is an alphabet
    if (alphabetToNumber.containsKey(char)) {
      // Replace it with the corresponding number
      result += alphabetToNumber[char]!;
    } else {
      // If it's not an alphabet (it could be a number or any other character), keep it as it is
      result += char;
    }
  }

  return result;
}
