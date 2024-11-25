---
title: INSY-PLSQL-2024
description: Slides for PLSQL by Michael Stenz
theme: gaia
color: #333
backgroundColor: #fff
backgroundImage: url('./img/hero-background.jpg')
footer: PL/SQL - Michael Stenz
_footer: ""
paginate: true
_paginate: false
marp: true
style: |
  pre, code {
    font-family: 'Fira Code', monospace;
    font-size: 1rem;
    color: #e06c75;
    background-color: #282c34;
    padding: 1rem;
    border-radius: 8px;
  }
------

<div style="display: flex; justify-content: center; flex-direction: column; height: 70%">
<h1>PL/SQL</h1>
<h6>Presentation von Michael Stenz</h6>
</div>

![bg right](./img/AppDev_plsql_detailed.svg)

---

# Allgemein
<ul>
    <li style="display: flex; align-items: center; list-style: none; position: relative;">
        <span style="position: absolute; left: -0.95em;">•</span>
        <p style="margin-top: 0">Entwickelt von </p>
        <img src="./img/oracle-logo-01.png" alt="oracle cooperation" style="height: 60px; margin-left: 5px;">
    </li>
    <li>Procedural Language extensions to SQL</li>
    <li>Seit Oracle 6.0 (1991)</li>
    <li>Erweiterung mit jeder Oracle Version</li>
</ul>

---

### History

- **Pro*C** (< 1991): Oracle SQL Statements in C
- **PL/SQL 1.0** (1991): Sehr limitiert
- **PL/SQL 2.1**: Prozeduren, Funktionen, Packages
- **PL/SQL 2.2**: Calling Stored Functions in SQL => DBMS_SQL package & DDL statements
- **PL/SQL 2.3**: Binary PL/SQL programs
- **PL/SQL 2.4**: File I/O Support & PL/SQL Table/Record improvements (wie Arrays)
- **Oracle 19c**: Polymorphic Table Functions in the same package -> USING optional

---

# Warum PL/SQL?

- Erweiterung durch 3GL-Elemente (Schleifen, Bedingungen, Prozeduren, Funktionen...)
- Auslagerung von Code/Business-logic in die Datenbank (Datenintegrität 👍, Keine Redundanz 👍)
- Vorbereitung und Speicherung Code (Precompiled im Datenbankcache ⚡)
- Zeit und Aktionsgesteuerte Ausführung (Trigger, Scheduler)
- Komplexe probleme -> einfache sub-programme
- ...

---

# Architektur

- **PL/SQL Engine** -> Komponente von Oracle die PL/SQL Blöcke ausführt
- Engine führt proceduralen Code aus und sendet SQL Statements an den Database Server

![bg right width:90%](./img/plsql-enviroment.gif)

---

# Blockstruktur

```sql
<< label >> (optional)
DECLARE    -- Declarative part (optional)
-- Declarations of local types, variables, & subprograms

BEGIN      -- Executable part (required)
-- Statements (which can use items declared in declarative part)

[EXCEPTION -- Exception-handling part (optional)
-- Exception handlers for exceptions (errors) raised in executable part]
END;
```

---

<div style="display: flex; justify-content: center; flex-direction: column; height: 70%">
<h1>Basics & Datenstrukturen</h1>
</div>

---

# Blockstruktur
Anonymer Block (nicht benannt)
```sql
BEGIN
-- Statements
END;
```
---

# Blockstruktur
Lokale Prozedur (nur innerhalb des Blocks)
```sql
DECLARE
    PROCEDURE my_proc IS
    BEGIN
        -- Statements
    END;
BEGIN
    my_proc; -- Nur innerhalb des Blocks aufrufbar
END;
```
---

# Blockstruktur
Stored Procedure (in DB gespeichert)
```sql
CREATE OR REPLACE PROCEDURE my_proc IS
BEGIN
    -- Statements
END;
```
---

# Variablen

```sql
identifier [CONSTANT] datentyp [NOT NULL] [:= | DEFAULT ausdruck]
```
```sql
DECLARE
  emp_count NUMBER(3) := 0;
  part_no NUMBER(4);
  in_stock BOOLEAN;
BEGIN
    select count(*) into emp_count from emp; --Variablen mittels statements zuweisen
END;
```

---

# %Type
Datentyp einer Spalte oder Variable
Verhindert Probleme bei Änderungen
```sql
DECLARE
  v_name emp.e_vname%TYPE
  n_name.emp.e_nname%TYPE
  tmpstr v_name%TYPE
BEGIN
```
[DEMO](./demos/type_demo.sql)

---

# %RowType
Datentyp einer Zeile einer Tabelle (Cursor)
```sql
DECLARE
    dept_row dept%ROWTYPE; 
BEGIN
    SELECT * INTO dept_row FROM dept WHERE deptno = 10;
END;
```

---

# Records

Kann mehrere Variablen verschiedener Datentypen speichern
Deklaration mit %ROWTYPE oder explizit
    
![bg right width:100% 90](./img/plsql-record.gif)

---

# Datentypen

- SQL Types + PL/SQL Types <!-- PL/SQL Datentypen und SQL Datentypen -->
  - z.B BOOLEAN
- Scalar (können subtypes haben)
- Composite
- Large Object (LOB)

![bg right width:90%](./img/datentypen.png)

<!-- https://docs.oracle.com/html/B28370_05/datatypes.htm -->

---

# Subtype

- Nur subset von von Basis Typ

```sql
SUBTYPE subtype_name IS base_type 
    { precision [, scale ] | RANGE low_value .. high_value } [ NOT NULL ]
```

[DEMO](./demos/subtype_demo.sql)

---

<div style="display: flex; justify-content: center; flex-direction: column; height: 70%">
<h1>Kontrollstrukturen</h1>
</div>

---

# IF-THEN-ELSIF
Klassische verzweigungen
```sql
IF <condition1> THEN
  <sequence_of_statements1>
ELSIF <condition2> THEN
  <sequence_of_statements2>
ELSE
  <sequence_of_statements3>
END IF;
```

---

# CASE
Vergleichbar mit IF-ELSE - wird effizienter ausgeführt. <br>Hierbei wird der selector verwendet anstatt bool'schen Ausdrücken
```sql
CASE selector
  WHEN expression1 THEN
    sequence_of_statements1;
  WHEN expression2 THEN
    sequence_of_statements2;
  ...
  [ELSE
    sequence_of_statementsN;]
END CASE;
```

---

# Searched CASE
Ohne Selector
```sql
CASE
  WHEN grade = 'A' THEN dbms_output.put_line('Excellent');
  WHEN grade = 'B' THEN dbms_output.put_line('Very Good');
  WHEN grade = 'C' THEN dbms_output.put_line('Good');
  WHEN grade = 'D' THEN dbms_output.put_line('Fair');
  WHEN grade = 'F' THEN dbms_output.put_line('Poor');
  ELSE dbms_output.put_line('Invalid grade');
END CASE;
```

---

# Case als Ausdruck
```sql
grade := CASE
  WHEN score >= 90 THEN 'A'
  WHEN score >= 80 THEN 'B'
  WHEN score >= 70 THEN 'C'
  WHEN score >= 60 THEN 'D'
  ELSE 'F'
END;
```

---

# Loop
Endlosschleife<br>
Benötigt **EXIT;** statement zum beenden.
```sql
LOOP
    -- statements
    EXIT WHEN <condition>; -- Gleich wie If-Then EXIT;
END LOOP;
```

---

# Benennung von Schleifen
Schleifen können bennennt werden um mit **EXIT** oder **CONTINUE** gezielt zu springen.
```sql
<<loop1>>
FOR i IN 1..10 LOOP
  <<loop2>>
  FOR j IN 1..10 LOOP
    EXIT loop1 WHEN <condition>;
  END loop;
END loop;
```

---

# While
```sql
WHILE <condition> LOOP
    -- statements
END LOOP;
```

---

# For-Loop
Die zähler variable ist ein Integer, und muss nicht deklariert werden. 
```sql
[<<loop_name>>]
FOR <counter> IN [REVERSE] <lower_bound>..<higher_bound> LOOP 
  <sequence_of_statements> -- Counter kann innerhalb des loops nicht zugewiesen werden.
END LOOP;
```

```sql
FOR i IN 1..10 LOOP
  dbms_output.put_line(i);
END LOOP;
```

---

<div style="display: flex; justify-content: center; flex-direction: column; height: 70%">
<h1>Cursor</h1>
</div>


---


# Quellen
- https://www.oracle.com/database/technologies/appdev/plsql.html
- https://docs.oracle.com/
- [PL/SQL Basicscriptum - Mag. Johannes Tumfart](PLSQL-Skript.pdf)
- [Einführung PL/SQL - Mag. Johannes Tumfart](EinführungPLSQL.pdf)