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