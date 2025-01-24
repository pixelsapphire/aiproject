## System ekspercki _"Should you be an engineer?"_

### Autorzy:
- **Olga Karaś (155992)**
- **Alex Pawelski (147412)**

### Język i zależności:
System jest zaimplementowany w języku Java. Jedyną wykorzystaną biblioteką zewnętrzną jest CLIPSJNI, która została dołączona w folderze `lib`. Podczas uruchamiania, należy dodać opcję `-Djava.library.path=lib`, aby wskazać folder z biblioteką CLIPSJNI, lub przenieść bibliotekę w miejsce wskazywane przez zmienną środowiskową `java.library.path`. Program był testowany na wersji Javy 23, jednak powinien być kompatybilny z każdą wersją Javy 8 lub wyższą (skompilowaną dla architektury i386 lub x86_64).

### Uruchomienie:

**IntelliJ Idea**: Projekt został napisany w środowisku IntelliJ IDEA, więc można otworzyć i uruchomić bezpośrednio.

**Gradle**: Można wykorzystać narzędzie Gradle (polecenie `gradle run`). W tym przypadku, nie jest konieczne dodawanie opcji `-Djava.library.path=lib`, ponieważ została ona dopisana do skryptu.

**Eclipse**: Projekt można otworzyć w Eclipse, korzystając z opcji importowania projektu. W tym calu należy:
1. uruchomić polecenie *File > Import*;
2. wybrać opcję *Gradle > Existing Gradle Project* i kliknąć przycisk *Next*
3. wskazać katalog z projektem i kliknąć *Finish*.
   ![Import projektu](https://i.imgur.com/SnrlfxJ.png)

Uruchomienie programu możliwe jest poprzez wybranie zadania `application` w zakładce *Gradle Tasks* i podwójne kliknięcie przycisku *Run*.
![Zadanie application](https://i.imgur.com/DZKtFYJ.png)
