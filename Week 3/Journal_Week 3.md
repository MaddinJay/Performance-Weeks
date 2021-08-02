# Day 11

Vorbereitungen:
 - Code Kata studiert
 - Da die Klassenstruktur vorgegeben ist, Test-Inbox zur Skizzierung der Klasse und der Akzeptanztests verwendet
 - Nach Verständnis der Aufgabe, zügig in die Umsetzung gehen

Umsetzung:
 - Mit einfachen Tests begonnen. 
 - Tests sukzessive für Player 1 und 2, und wiederholter Ausführung aufgebaut
 - Leiter und Schlangenlogik vorerst nicht berücksichtigt. 
 - Umsetzung klappt sehr flüssig
 - Für Player im Laufe der Porgrammierung eine Klasse eingeführt und die IF/COND Statements so minimiert

Lesson Learned:
 - Ist die Struktur der Aufruferklasse klar, ist eine Integration von Tests sehr schnell möglich
 - Der Fokus kann auf die Klassenlogik gerichtet werden
 - Prinzip der kleinen Schritte ist sehr mächtig
 - Keep it simple gibt die Möglichkeit einen Flow aufzubauen
 - Weitere Klassenkapselung wird zwangsläufig während der Programmierung klar
 - Big Picture at Front ist nicht sinnvoll, da die vorab im Kopf befindliche Struktur sich mit der weiteren Umsetzung
   schnell ändert.
 - Gewichtung der Akzeptanztests während der Programmierung kann geändert werden. 
 - Es kann auch sinnvoll sein, Boundarie-Tests (Game Over, Player Wins) weiter nach hinten zu verlegen, um den
   Flow nicht zu stören. Hier geschehen. Erst Fokus auf Integration der Klassen gelegt.

# Day 12

Vorbereitungen:
 - Fokus auf Snake/Ladder Logik legen
 - Da Spielklasse und Methode klar, einfach "drauf los porgrammieren"
 - Fokus auf einen Spieler
 - Fokus lediglich auf die Snake/Ladder Logik, mehrere Runden und Spielerwechsel hinten anstellen

Umsetzung:
 - Begonnen wird mit einfacher Ausführung, Zahl kommt zurück
 - Logik zur Leiter implementiert, mehrere Felder prüfen, erst Tabelle angelegt, dann in Objekt ausgelagert
 - Logik zur Snake implementiert, analog Ladder-Logik
 - Einführung Interface. da aufgerufene Methode von Ladder/Snake identisch
 
Lesson Learned:
 - Einfache Spiellogik ermöglicht schnelle Implementierung
 - TPP ist gutes Mittel, um Logikstruktur "wachsen" zu lassen
 - Keep it simple weiterhin eine gute Vorgehensweise
 - Auch hier wieder im Laufe der Programmierung Struktur besser erkannt und Strategie gewechselt: Zuerst beide Klassen Ladder und Snake eingeführt, dann
   erst Interface angelegt. 

# Day 13

Vorbereitungen:
 - London School of TDD anwenden
 - Skizze der GUI-Logik via PIZZA erstellt

Umsetzung:
 - Fokus auf GUI-Aufbau, mit Status und einem Spieldurchgang
 - Fokus auf Spiel durch Player 1. Noch keine Logik in der Klasse implementieren
 - Einfache Addition der Würfelaugen in der Method PLAY
 - UNIT-Tests nicht aufgebaut, weil visuelle Prüfung über GUI erfolgt

Lesson Learned:
 - Spannend, wieder mal bereits die Architektur der Anwendung zu konstruieren
 - Durch Ausblenden der Spiellogik fällt der Fokus auf die Architektur leicht
 - Klassenstruktur erweitert (alle Anforderungen sind falsch), damit die Ergebnisse für
   beide Spieler leichter zu visualisieren sind.
 - Auch Ergebnisstring-Aufbau erst einmal in die GUI ausgelagert, da zum jetzigen Zeitpunkt dies
   logischer und strukturierter erscheint (Anforderung an Method PLAY geöndert)
 - Starres Beharren auf die Struktur der Klasse macht keinen Sinn. Flexibel in der Lösungsfindung bleiben.

# Day 14

Vorbereitungen:
 - Ziel setzen: TPP und ZOPMBIES anwenden

Umsetzung:
 - Ersten Testfall "Runde 1- Player 1" definiert
 - Testfall ausgebaut zu "Runde 1 - Player 1 und 2" 
 - Tesfall "Runde 2 - Player 1" definiert und dann weiter ausgebaut, analog erster Testfall
 - Konzentration auf Integration der Player in Spielklasse
 - Implementierung soll weiter modfiziert werden, Duplikation mit Player 1 und 2 entfernt werden

Lesson Learned:
 - Konzentration auf kleine Schritte
 - Design wächst immer fort
 - Zeit ist imme knapp, daher lohnenswert, immer auf Sauberkeit zu achten
 - Abschliessende Ergebnisse in der kürze der Zeit nicht möglich, daher Fokus auf Zwischenziele wichtig

# Day 15

Vorbereitungen:
 - Die drei Spielvarianten "Player x on square Y", "Player X wins" und "Game over!" als Akzeptanztests definiert
 - Spiellogik mit wechselnden Spielern für später vorgemerkt

Umsetzung:
 - Anlage der Vier Akzeptanztests mit leerer Implementierung
 - Sukzessive Implementierung der Akzeptanztests
 - Verwendung von Hilfsmethoden im Test-Double, um finale Spielschritte zu simulieren

Lesson Learned:
 - Logik und Fokus auf Workflow (Wechselnde Spielter) hinten angestellt. Wirkt ein wenig irritierend.
 - Durch Fokus auf Akzeptanztests ist Logik sehr simpel, es entsteht ein guter Flow bei der Entwicklung. 
 - IOSP, TPP und ZOMBIES kann gut angewendet werden
 - Mit Endergebnis soweit zufrieden, nächste Schritte dann weitere Kapselung in Objekte und Spiellogik weiter
   modellieren.