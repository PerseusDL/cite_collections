latin-lex-collection
====================

Source files for Perseus Latin Lexical Entity CITE Collection

Tufts University holds the overall copyright to the Perseus Digital Library; the materials therein (including all texts, translations, images, descriptions, drawings, etc.) are provided for the personal use of students, scholars, and the public.

Materials within the Perseus DL have varying copyright status: please contact the project for more information about a specific component or object. Copyright is protected by the copyright laws of the United States and the Universal Copyright Convention.

Lexical entity data and short definitions seeding this collection are derived from data coming from Perseus, Philologic at the University of Chicago, and the Alpheios Project, Ltd.

Unless otherwise indicated, all contents of this repository are licensed under a Creative Commons Attribution-ShareAlike 3.0 United States License. You must offer Perseus any modifications you make. Perseus provides credit for all accepted changes.

====================

##Files

inventory_import.csv is the csv file used for the import to the Google Fusion table that serves as the main data source for the inventory. (Columns are urn, normalized lemma, short def, status, redirect, added_by, edited_by)

lexicon.ttl is a set of triples that include the sources of the lexical entities.  I'm just using very basic vocabulary for now. For future work we need to explore standard ontologies for lexical resources including GOLD, Olia, LMM, Lemon, etc. 

`lexicalentityurn rdfs:label normalizedlemma`
`lexicalentityurn dcterms:description shortdef`
`lexicalentityurn dcterms:isReferencedBy lexiconurl`
`lexicalentityurn perseus:hasMorpheusLemma "lemma"@lat`
`lexicalentityurn dcterms:isReplacedBy lexicalentityurn`
	

redirects contains list of entity urns that I think are probably ones that should either be redirected or not be in the inventory at all. Tab separated columns are urn, original entity text, morpheus output (if any).

## Notes on Collection Creation

For full details, see the parse.pl script in the src.tgz archive.

1. Extracted all distinct lemmas (and any available short defs) from 
    1. Lewis & Short Lexicon (via Alpheios index)
    1. Perseus hib_entities table
    1. Philologic DB 
2. Created normalized label for each lemmas by:
    1. stripping vowel length, accents and dipthongs (ae/oe)
    1. retaining case
3. Ran each distinct lemma through morpheus to see if it parsed.
4. Mapped morpheus lemmas to corresponding urn
5. For any entities whose short def matched '\\N' in a Perseus lexicon and which do not start with an initial cap (indicating a named entity):
    1. set initial status to 'review' instead of 'proposed'
    1. tried to parse the actual lexicon xml for the entity and if it looked to be pointing at an see reference and that reference was a lemma we have then identify the urn(s) as possible redirects
6. Output triples and csv import file
