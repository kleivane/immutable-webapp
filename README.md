# Immutable-webapp
En implementasjon av stukturen fra https://immutablewebapps.org/

# AWS-oppsett med Cloudfront og S3
* Bucket med statiske assets med `cache-control: public, max-age=31536000, immutable`
* Bucket *test* og *prod* med *kun* index.html og `cache-control: no-store`
* Cloudfront foran med redirects til rett buckets
* Se immutable-webapp-*env* på https://github.com/kleivane/immutable-infrastructure for terraform-oppsett


# Alternativer
* Slå sammen deploy-assets og deploy-test
* Bytte ut git-sha med [build-numbers](https://github.com/marketplace/actions/build-number-generator)
* ordentlige bekk-urler til relativt statiske aws-urler
* tester på deploytid
* CSS og bilder inn i `npm run build`
* Sette opp en ok utvilkingsprosess for js
* Backend (helsesjekker og overvåking)
* Database
* Pålogging
* Sikkerhet
* shared state / remote backend i terraform
* terraform outputs som som github-secret
* secrets lokalt for å kjøre terraform
* secrets lokalt for å trigge githubaction

# Prodsetting
```
curl -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token <your-token-here>" \
    --request POST \
    --data '{"event_type": "trigger-production", "client_payload": { "dummy": "a dummy example"}}' \
https://api.github.com/repos/kleivane/immutable-webapp/dispatches```
