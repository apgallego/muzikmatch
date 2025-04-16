//camelot wheel
class CamelotWheel {
  // Asignación de tonalidades para simplificar
  static const camelotKeys = {
    '1B': 'C',
    '2B': 'G',
    '3B': 'D',
    '4B': 'A',
    '5B': 'E',
    '6B': 'B',
    '7B': 'F#',
    '8B': 'Db',
    '9B': 'Ab',
    '10B': 'Eb',
    '11B': 'Bb',
    '12B': 'F',
  };

  // Lista de tonalidades adyacentes
  static const adjacentKeys = {
    '1B': ['2B', '12B'],
    '2B': ['1B', '3B'],
    '3B': ['2B', '4B'],
    '4B': ['3B', '5B'],
    '5B': ['4B', '6B'],
    '6B': ['5B', '7B'],
    '7B': ['6B', '8B'],
    '8B': ['7B', '9B'],
    '9B': ['8B', '10B'],
    '10B': ['9B', '11B'],
    '11B': ['10B', '12B'],
    '12B': ['11B', '1B'],
  };

  // get adjacent keys
  static List<String> getAdjacentKeys(String key) {
    return adjacentKeys[key] ?? [];
  }
}
