# Day 6

Vorbereitungen:
 - Code Kata studiert
 - PIZZA angewendet, um die Aufgabe zu greifen
 - Problem auf eine Zelle runtergebrochen, um in die Umsetzung zu gehen
 - Die Regeln als Akzeptanztests definiert, um den Algorithmus greifen zu können
 - Chicago School of TDD anwenden, weil die Aufgabenstellung noch nicht klar genug erscheint

Umsetzung:
 - Anfang mit erstem Akzeptanztest
 - Definition der Zelle und Nachbarn als 3x3 Tabelle
 - Tabellenkonzept verworfen, Zellenstruktur geändert, um den Algorithmus leichter umzusetzen
 - Akzeptanztests nach und nach aufgebaut
 - Refactoring erst zum Schluss richtig durchgeführt

Lesson Learned:
 - Falls man keine Ahnung hat, wie der Algorithmus wirklich ablaufen soll, bietet sich Chicage School of TDD gut an
 - Akzeptanztests geben ein gutes Gefühl für die erste Umsetzungslogik und setzen einen guten Anker
 - Verwerfen von Ansätzen erleichtert das weitere Vorgehen
 - Umsetzung bis dahin im Flow erfolgt
 - Für grössere Konezepte fehlt der Überblick zu anfangs
 - Mit weiteren Akzeptanztests kristallisiert sich eine Struktur heraus

# Day 7

Vorbereitungen:
 - Analyse des Spiels, Einsatz des Algorithmus
 - Problemstellung runter gebrochen auf ein 4x4 Gitter
 - Akzeptanztest definiert als ein Snapshot, welcher den Status durch einen Durchlauf des Algorithmus wechselt

Umsetzung:
 - Erstellen erster Test bezogen auf Zelle B2, welche den Status von lebend auf tot wechselt
 - Erstellen zweiter Test bezogen auf Zelle A1, welche den Status von tot auf lebend wechselt
 - Erstellen dritten Test bezogen auf Wechselwirkung von Statuswechsel A1 auf B2 (Anzahl Nachbarn erhöhen) (Obsover Pattern)

Lesson Learned:
 - Akzeptanztest eines konkrteten Statuswechsels hilft dabei, das Spiel besser zu verstehen
 - Baby Steps beim Testing lassen einen guten Flow erzeugen
 - Mit dem Vorwissen von gestern deutlich einfacher umzusetzen heute
 - Übung gestern sehe ich als Warm Up für die Umsetzung heute. Reinfühlen, Problem verstehen, Überblick verschaffen durch konkrete Umsetzung
 - Neuer Ansatz viel erfolgsversprechender als der Ansatz von gestern -> Mut aufbringen, Lösungen einfach weg zuwerfen und neu anzufangen 


# Day 8

Vorbereitungen:
 - Fokus auf Observer Pattern: Informiere Nachbarn, dass Zelle aktiviert bzw. gelöscht wurde
 - Feldbelegung wie gestern beibehalten
 - Fokus heute vorwiegend auf flüssige Umsetzung, ohne gross vorab zu analysieren. Problem wird klarer.

Umsetzung:
 - Zwei UNIT-Tests subzessive angelegt, Zelle als Nachbar hinzufügen, falls Zelle aktiviert wird; Zelle als Nachbar löschen, wenn Zelle stirbt
 - Zwei Akzeptanztests definiert, diese dann als Tests angelegt
 - Aktive Nachbarn diesmal in Liste von Nachbarn in der Zelle gepflegt
 - Ersten UNIT-Test dann erweitert um Liste von Objekten. Zu Beginn nur einen Nachbarn erfasst
 - Idee zum Weitermachen: Liste der Nachbarn ebenfalls in einem Objekt festhalten. Vererbung von YCL_CELL.

Lesson Learned:
 - Observer Pattern gut anwednbar. Initiale Idee bestätigt sich gut.
 - Prinzip der kleinen Schritte ist sehr gut anwendbar. So entsteht ein guter Flow
 - Programmierung selbst wird flüssiger. Regelmässige Übung zahlt sich aus.
 - Everythin is an Object, ein sehr sinnvolles Prinzip. Die Objekte sind so leicht zu handeln.
 - Für L
 - Keine Hektik, auch wenn Zeit abläuft. Lieber in Qualittät als Quantität investieren.

# Day 9

Vorbereitungen:
 - Fokus auf London School of TDD, Walking Skeleton
 - Ziel definiert: SAP GUI erstellen, so dass eine Spielrunde visualisiert wird

Umsetzung:
 - Reportanlage mit Screen relativ zügig umgesetzt. 
 - Erst ohne Verarbeitungsklasse gearbeitet.
 - Screen eingebunden, wobei die Anlage des STATUS mit anschliessenden Zurückspringen sehr schleppend verlief.
 - Als Workflow stand, Klasse für die Verarbeitung integriert. 
 - Noch keine UNIT-Tests angelegt, da erst einmal mit Dummywerten gearbeitet wird.

Lesson Learned:
 - Programmierung von Klassen und Handling von Eclipse wird zügiger.
 - Reportanlage mit Screen und Navigation arg in Vergessenheit geraten -> Nächstes Mal vorab auffrischen
 - Durch schleppende STATUS-Integration kein richtiger Flow entstanden im ersten Teil der Umsetzung.
 - Den Workflow gleich anfangs zu integrieren ist vergleichsweise mühsam.
 - Wenn Workflow steht, überwiegt die Visualisierung der Ergebnisse. Echter Mehrwert.
 - Workflow gibt auch gute Struktur vor, wie es weitergehen kann mit der Integration der nächsten Klasse(n)

# Day 10

Vorbereitungen:
 - Weiterhin Fokus auf London School of TDD
 - Ziel definiert: Selber Ansatz wie am Tag 9, durch flüssigere Umsetzung weiter im Konzept kommen.
 - Insbesondere anfangen mit dem Transfer des Protocol-Spielfeldes in handelbare Zell-Objekte

Umsetzung:
 - Report analog Tag 9 angelegt. Visualisierung sehr zügig erreicht. 
 - Leicht gespickt, als es darum geht, die ALV-Klasse zu integrieren.
 - Navigation vom GUI Dynpro gelingt auf Anhieb.
 - Vorerst Verzicht auf UNIT-Tests, da durch Fachtest das Ergebnis vergleichbar ist
 - Dann Integration des Transfers der Tabellenansicht für das Spielfeld in eine Zell-Objekt-Liste
 - Flow kann beibehalten werden, Duplizierte Methoden werden als TODO festgehalten, da vorerst nicht
   der Flow gestärt werden soll.
 - Erste Zellobkjekte aufgebaut, Logik noch nicht final. Weitere Kapselung/Auslagerung sicherlich später sinnvoll.

Lesson Learned:
 - Mit jedem Neuansatz gestaltet sich die Lösung immer ein wenig anders.
 - Konzentration auf Form wahren. Nicht zu schnell vorwärts wollen, sondern den Refactoring-Zyklus konzentriert annehmen
 - Anlage GUI klappt wieder leicht -> Gute Vorbereitung sicherlich manchmal sinnvoll.
 - Code-Katas mehrfach hinterinander zu wiederholen erscheint sinnvoll, da Lösungsalternativfindung gestärkt wird. 