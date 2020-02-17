# Immutable-webapp
En implementasjon av stukturen fra https://immutablewebapps.org/

## Gode sky-prinsipper
* Infrastruktur som kode
* Deploy av kode og infrastruktur skal skje fra ci
* Utviklere skal ha rettigheter som ikke stopper dem fra å teste og utforske
* Prod skal ha annen tilgangsstyring enn test
* Bygget kode skal kunne deployes til alle miljøer - config skal leve et annet sted
* Den eneste hemmeligheten utenfor infrastrukturen skal egentlig være access-keys
* Gjør deg kjent med verktøyene i skyplattformen, deres styrker og svakheter, følg med på nyheter :)
* Om to produkter kan løse samme oppgaven, velg den som gir minst vedlikeholdsarbeide

# Bygging av assets

Oppsettet er slik at `npm run build` er forventet å lage filer som pakkes med alt som trengs og flyttes til `build`.
Denne mappen må inneholde en fil `main.js` som er tilpasset å kjøre i den `index.html`-filen som genereres i `src-lambda/main.js`.

# AWS-oppsett med Cloudfront og S3
Se terraform/*env* undermappene for eksakt oppsett

Modulen `terraform-aws-cloudfront-s3-assets` gjør + sync-oppsett på GH-actions gjør følgende 

* Bucket med statiske assets med `cache-control: public, max-age=31536000, immutable`
* Bucket *test* og *prod* med *kun* index.html og `cache-control: no-store`
* Cloudfront foran med redirects til rett buckets



# Alternativer
* Bytte ut git-sha med [build-numbers](https://github.com/marketplace/actions/build-number-generator)
* ordentlige bekk-urler til relativt statiske aws-urler
* tester på deploytid
* CSS og bilder inn i `npm run build`
* Backend (helsesjekker og overvåking)
* Database
* Pålogging
* Sikkerhet (vault eller andre, aws systems manager + KMS)
* terraform outputs som som github-secret
* terraform på ci
* secrets lokalt for å kjøre terraform
* secrets lokalt for å trigge githubaction

# Prodsetting
Push en tag til github på formatet `x.y.z` og det vil trigge en githubaction som starter en deploy av taggen til produksjon.
