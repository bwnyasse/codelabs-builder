dart pub global activate remove_from_coverage
dart pub global activate coverage

dart pub global run coverage:test_with_coverage

remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$'

genhtml coverage/lcov.info --output=coverage 

open coverage/index.html