1) SELECT * FROM `studenti`
2) SELECT * FROM `Studenti` WHERE ciclo="laurea sp."
3) SELECT * FROM `Studenti` WHERE ciclo="laurea sp." ORDER BY nome DESC
4) SELECT DISTINCT s.* FROM `Studenti` s ,`Esami` e  WHERE s.matricola=e.studente and e.voto>20
5) SELECT DISTINCT c.* FROM `Corsi` c, `Esami` e, `Studenti` s WHERE s.matricola=e.studente and e.corso=c.codice and s.ciclo="laurea tr." and e.voto>25
6) SELECT s.* FROM `Studenti` s, `Professori` p WHERE s.relatore=p.codice and p.qualifica="ricercatore"
7) SELECT s.* FROM `Studenti` s, `Professori` p WHERE s.relatore=p.codice and s.ciclo="laurea sp." and s.anno="1" and p.dipartimento="Ing"
8) SELECT s.* FROM `Studenti` s,`Studenti` s1, `Tutorato` t WHERE s.matricola=t.tutor and t.studente=s1.matricola and s1.anno="1"
9) SELECT DISTINCT s.* FROM `Studenti` s,`Studenti` s1, `Tutorato` t , `Esami` e WHERE s.matricola=t.tutor and t.studente=s1.matricola and s1.matricola=e.studente and e.voto="30" and e.lode="1"
10) SELECT s.* FROM `Studenti` s, `Tutorato` t, `Esami` e WHERE s.matricola=t.tutor and s.matricola=e.studente and 29<all(SELECT e.voto FROM `Esami` e WHERE s.matricola=e.studente)
11) SELECT DISTINCT c.* FROM `Esami` e, `Corsi` c WHERE e.corso=c.codice and 25 < all(SELECT e.voto FROM `Esami` e WHERE c.codice=e.corso)
12) SELECT DISTINCT p.* FROM `Professori` p, `Studenti` s, `Esami` e WHERE s.relatore=p.codice and s.matricola=e.studente and 24<all(SELECT e.voto FROM `Esami` e WHERE s.matricola=e.studente)
13) SELECT DISTINCT n.numero FROM `Numeri` n, `Professori` p WHERE n.professore=p.codice and not exists (SELECT p.* FROM `Studenti` s, `Professori` WHERE s.relatore=p.codice)
14) SELECT DISTINCT c.* FROM `Corsi` c, `Esami` e, `Studenti` s WHERE s.anno="1" and s.ciclo="laurea tr." and s.matricola=e.studente and e.corso=c.codice and c.ciclo="laurea sp."
15) SELECT DISTINCT c.* FROM `Corsi` c, `Professori` p WHERE c.docente=p.codice and p.qualifica="ricercatore" and exists (SELECT s.* FROM `Studenti` s, `Esami` e WHERE s.matricola=e.studente and e.corso=c.codice)
