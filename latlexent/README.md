latin-lex-collection
====================

Source files for Perseus Latin Lexical Entity CITE Collection

Tufts University holds the overall copyright to the Perseus Digital Library; the materials therein (including all texts, translations, images, descriptions, drawings, etc.) are provided for the personal use of students, scholars, and the public.

Materials within the Perseus DL have varying copyright status: please contact the project for more information about a specific component or object. Copyright is protected by the copyright laws of the United States and the Universal Copyright Convention.

Lexical entity data and short definitions seeding this collection are derived from data coming from Perseus, Philologic at the University of Chicago, and the Alpheios Project, Ltd.

Unless otherwise indicated, all contents of this repository are licensed under a Creative Commons Attribution-ShareAlike 3.0 United States License. You must offer Perseus any modifications you make. Perseus provides credit for all accepted changes.

====================

##Files

inventory_import.csv is the csv file I'll use for the import to the Google Fusion table that will serve as the main data source for the inventory. (Columns are urn, normalized lemma, short def, status and redirect)

lexicon.ttl is a sample set of triples that include the sources of the lexical entities.  I'm just using basic vocabulary for now have made up a urn syntax for the morpheus lemmas urn:morpheus:latin:lemma:MORPHLEMMA (e.g. urn:morpheus:latin:lemma:occido1). We can figure out the exact vocabulary to use later, but I wanted to record the provenance of the entities in some way.

`lexicalentityurn rdfs:label normalizedlemma`

`lexicalentityurn rdfs:isDefinedBy lexiconurl`

`morpheusurn owl:sameAs lexicalentityurn`

redirects contains list of entity urns that I think are probably ones that should either be redirected or not be in the inventory at all. Tab separated columns are urn, original entity text, morpheus output (if any).

Might be good to take another pass or two through the base inventory to automatically provide redirects for named entities and verbal adjectives.

## Notes on Collection Creation

For full details, see the parse.pl script in the src.tgz archive.

1. Extracted all distinct lemmas (and any available short defs) from 
    a. Lewis & Short Lexicon (via Alpheios index)
    b. Perseus hib_entities table
    c. Philologic DB 
2. Created normalized label for each lemmas by:
    a. strip vowel length, accents and dipthongs (ae/oe)
    b. retain case
3. Ran each distinct lemma through morpheus to see if it parsed.
4. Mapped morpheus lemmas to corresponding urn
5. Output triples and csv import file
