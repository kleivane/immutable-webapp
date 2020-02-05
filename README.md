# Immutable-webapp
En implementasjon av stukturen fra https://immutablewebapps.org/

# Deploy
Deploy av index.html `npm run deploy -- -sha <GIT_SHA>`

# AWS-oppsett
* Bucket repo med `cache-control: public, max-age=31536000, immutable`
* Bucket test med *kun* index.html og `cache-control: no-store`
* TEST: cloudformation med 2 origins, repo og index og behaviors.


# Alternativer
* Slå sammen deploy-assets og deploy-test
* Bytte ut git-sha med [build-numbers](https://github.com/marketplace/actions/build-number-generator)
* 2 miljøer
* ordentlige urler 
* tester på deploytid
* CSS og bilder inn i `npm run build`
* Sette opp en ok utvilkingsprosess for js
* Terraform for AWS-oppsettet
* Backend
* Database
