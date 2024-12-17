## System ekspercki _"Should you be an engineer?"_

### Autorzy:
- **Olga Karaś (151992)**
- **Alex Pawelski (147412)**

### Język i zależności:
Program został napisany w języku Java. Jedyną wykorzystaną biblioteką zewnętrzną jest CLIPSJNI, która została dołączona w folderze `lib`. Podczas uruchamiania, należy dodać opcję `-Djava.library.path=lib`, aby wskazać folder z biblioteką CLIPSJNI, lub przenieść bibliotekę w miejsce wskazywane przez zmienną środowiskową `java.library.path`.

### Uruchomienie:
Program był testowany na wersji Javy 23, jednak powinien być kompatybilny z każdą wersją Javy 8 lub wyższą (skompilowaną dla architektury i386 lub x86_64).
Projekt można otworzyć i uruchomić bezpośrednio w środowisku IntelliJ IDEA.
Można także wykorzystać narzędzie Gradle (polecenie `gradle run`). W tym przypadku, nie jest konieczne dodawanie opcji `-Djava.library.path=lib`, ponieważ została ona dopisana do skryptu Gradle.
