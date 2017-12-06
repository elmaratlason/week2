# Automated acceptance testing

## Costs less than frequent manual regression testing
- when properly done
- þarft að vita hvað þú ert að gera
-- 

## Costs less than releasing poor-quality software
- viljum grípa villur helst áður en við gefum út
- geta sagst ætla að laga eitthvað áður en við gefum út, t.d. fresta útgáfu.
- 

## Manual testing phases
- add a lot to the cycle time
- oft gerð undir mikilli pressu
- lagfæringar á hlutum leiða til regression

## Catch error classes that other tests do not
- einingapróf ættu að covera 100% en prófari ætti að vinna í exploratory (manual) testing
### are unit and component test enough?
- do not test user scenarios
- do not go through series of states
- unit test oft ekki í þráðum
- fáum ekki environment/configuration villur
- acceptance test are goot to catch:
-- thread problems
-- event-driven applications
-- architectural mistakes
-- configuration problems

## Acceptance test protect your application when
- making large-scale changes to it
- shortens the feedback loop, bugs are found sooner

## dangerous?
- hard to do properly
- UI tests introduce a lot of rigidity
-- getur haldið aftur af þróun
-- drivers/adapteres need to be maintained
-- ui will evolve slower as a result

## conclusion
- Use a handful of automated acceptance test through UI
-- < 5, one may be enough
- bulk of acceptance test should be through services
-- through the UI
- have the bulk in unit levelk

## how to create maintainable acceptance test suites
- careful attention to the analysis process
-- horfa á ferlið, millifæra, úttekt, staða á reikning eftir
- hafa þetta sem conclusion sögum (invest)


## Roles
- analyst
- tester

## summary
- viðbót, ekki meira/minna mikilvægt
- eykur traust á því að kerfið skili því sem það á að skila
- hjálpar til við stórar breytingar, validation
- losar fólk til að vinna frekar í explatory, user experience
- reduces cycle time
