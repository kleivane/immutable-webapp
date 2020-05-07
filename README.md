# Immutable-webapp
En implementasjon av stukturen fra https://immutablewebapps.org/ .

[Slides](https://docs.google.com/presentation/d/1gcnwG0NzTiAlQ9NrjWCTa6c0yCiKYEkowBLn9BSKbjA/present)

## Forberedelser

- Opprett en fork av dette repoet på din egen bruker og klon det ned på egen maskin
- Sjekk at `node` og `npm` er installert
- `brew install awscli`
- `brew install terraform`
- `git --version` er større en 2.9 (om du har lavere versjon, drop githook som er nevnt senere)
- Opprett en AWS-konto på https://aws.amazon.com/.
    - Bruk Basic-versjonen
    - Legg inn betalingskort <- følg med på kostnadene og husk å slette infrastrukturen som koster penger når dagen er ferdig
- Opprett en ny bruker i [IAM](https://console.aws.amazon.com/iam/home?#/users).
    - Add user: username `terraform` og access type `Programmatic access`
    - Permissions: `Attach existing policies directly` og velg policyen med policy name `AdministratorAccess`
    - Tags: name = `system` og value=`terraform`
    - Etter Create,husk å last ned access-key og secret.
- Kjør kommandoen `aws configure` med ACCESS_KEY_ID og SECRET_ACCESS_KEY som du fikk fra brukeren over. Bruk region `eu-north-1`
    - Kommandoen `aws iam get-user` kan brukes som en ping og sjekk av alt ok!
    - Når vi senere skal bruke terraform til å sette opp vår infrastruktur, er det credentials konfigurert gjennom aws-cliet over som terraform også bruker som credentials

Om du allerede nå ser at du vil lage noe under et eget domene, anbefaler jeg å gå inn på AWS Route 53 og opprettet et billig et med en gang. Selv om det sikkert går mye fortere, advarere Amazon om at det kan ta opp til 3 dager.

## Bli kjent

### Om appen

### Lokal oppstart

* Kjør opp appen med `npm install && npm run start`
* Generer en index.html med `node src-index/main.js`
* Gjør deg kjent med hvor de forskjellige inputene og env-variablene i appen kommer fra

## Min første immutable webapp

Felles mål her er en immutable webapp med to S3-buckets og et CDN foran som hoster index.html og kildekode.

Nyttige lenker:
* Om du ikke er veldig kjent i aws-konsollen fra før, anbefaler jeg å sjekke ut de forskjellige servicene
underveise
    - https://console.aws.amazon.com/s3
    - https://console.aws.amazon.com/cloudfront
    - https://console.aws.amazon.com/route53
* [Terraform-docs](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [AWS-cli-docs](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html)


### Testmiljø med buckets

Opprett to [buckets](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html) med terraform som skal bli der vi server asset og host. Start i `terraform/test/main.tf`. Husk at S3-bucketnavn må være unike innenfor en region!

Anbefalt terraform-output for begge buckets:
* bucket_domain_name - denne lenken kan du bruke til å aksessere filene du har lastet opp
* id - navnet på bucketen du har opprettet

Når begge bucket er oppprettet uten mer oppsett, og du kan gå inn i konsollen på web og manuelt laste opp en tilfeldig fil. Den vil ikke tilgjengelig på internett via `bucket_domain_name/filnavn`, ettersom default-policyen er at bucket er private. Vi kan konfigurere public tilgang ved å bruke acl-parameteret på en bucket eller en bucket policy. Sistnevnte er anbefalt av AWS  ettersom bucketacl er et eldre og skjørere konsept.

Opprett bucketpolicies for begge bøttene ved å bruke [`aws_s3_bucket_policy`](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html). I policy-atributtet kan du bruke en [templatefile](https://www.terraform.io/docs/configuration/functions/templatefile.html) med fila `policy/public_bucket.json.tpl`. Denne trenger en variabel `bucket_arn`. Bruk atributtet fra bucketen for å sende inn rett arn.

Se [policy.md](terraform/test/policy/policy.md) for en forklaring på innholdet i policyen.


### Bruke AWS-cliet til opplasting av filer

Bygg assets lokalt med `npm run build` og bruk aws-cliet til å laste opp alt innholdet i build-mappen til asset-bucketen under navnet `assets/id`. Velg en tilfeldig id for testen, senere skal vi bruke githash! Test at fila blir tilgjengelig i browseren på `<bucket_domain_name>/assets/id/main.js` og sett rett cachcontrol-headers.


`aws s3 cp <LocalPath> <S3Uri>`

Se [AWS-cli-docs](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html) for `aws s3 cp`

<details><summary>Tips</summary>
<p>

- bruk følgende S3-uri `s3://bucket-name/assets/1/`
- `--recursive` laster opp hele mappen
- `--cache-control public,max-age=31536000,immutable` setter cache-controls-headerne til alltid lagre som beskrevet i https://immutablewebapps.org/
</p>
</details>

Gjør endringer i `sha` og `url` i `src-index/main.js` for å peke på bucket og fila du har lastet opp over.
Bygg index.html (`node src-index/main.js`) og bruk `aws s3 cp` igjen for å kopiere index.html til host-bucket. Husk rett headers

Om du nå går på `<bucket_domain_name>/index.html` bør du se en kjørende applikasjon.

<details><summary>Tips</summary>
<p>

- Bruk `index.html` både som localPath og `s3://bucket-host-name/index.html` som S3Uri ettersom vi kun laster opp en fil
- `--cache-control no-store` setter cache-controls-headerne til aldri lagre som beskrevet i https://immutablewebapps.org/
</p>
</details>


### Autodeploy av assets med Github Actions

Nå skal vi la Github Actions overta bygging av assets og opplasting til assets-bucketen under unike versjonsnavn.
For enkelhets skyld er versjonsnavnet her `assets/sha/`. Vi skal bruke de samme kommandoene som over,
men la det utførest av github.

- I `.github/workflows/nodejs.yml` er det starten på en workflow. Fullfør denne slik at bygg og kopier filer til assets-bucketen skjer på hver push.
- I run-delen av en githubaction kan man hente ut commit med `${{github.sha}}`, se [docs](https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions). Tilsvarende kan den hentes ut i `src-index/main.js som `process.env.GITHUB_SHA`

Det finnes en githook som linter yml-filer for å slippe unna enkelte yml-feil i workflow-definisjonen.
Om du ønsker å ta den i bruk kan du kjøre kommandoen `git config core.hooksPath .githooks`


### Autodeploy til host
- Utvid `.github/workflows/nodejs.yml` til også å generere og laste opp index.html i host-bucketen. Sjekk ut tilgjengelige variable for node i [docs](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables).


### CDN

AWS CloudFront er Amazon sin CDN-provider, se [terraform-docs](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html).
Om du gjør dette for første gang anbefaler jeg at du starter med et cloudfront-domene og heller endrer til eget domene i neste steg.

For å mappe terraform-input til rett verdier, anbefaler jeg å se i aws-konsollen på CloudFront og velge "Create a distribution".
En gotcha som er fin å vite om, dersom du [ikke setter verdier i ttl-atributtene](https://github.com/terraform-providers/terraform-provider-aws/issues/1994) til terraform vil dette gjøre at CloudFront velger å bruker cachecontrol-headers fra origin, tilsvarende `Use Origin Cache Headers` fra AWS-console'en.

Figuren bakerst i slidesettet gir en slags oversikt av hvordan CloudFront passer inn som server for både host og assets - men dette var også den vanskeligste delen av oppgaven å beskrive! Så vær så snill å stikk innom Tine eller andre om det ikke gir mening.

Test ut endringer i `App.jsx` og deploy ny versjon av assets og index for å sjekke caching og endringer.
- OBS: Nå kan du bruke `domain_name` outputen fra cloudfront som erstatning for `my-url` i `src-index/main.js`

<details><summary>Tips</summary>
<p>

- du trenger en `origin` pr. s3 bucket
- `enabled`, `restrictions`, `viewer_certificate` kan være default
- `default_root_object` er `index.html`
- `default_cache_behavior` og `ordered_cache_behavior` kan ha like configparameter, men default må peke på host-bucket og ordered_cache_behavior på assets. Path `assets/*` matcher url-strukturen fra index.html

</p>
</details>

Løsningsforslag i repoet frem til hit ligger under https://github.com/kleivane/immutable-webapp/tree/master/terraform/test-1 .

## Alternativer videre (bruk rekkefølgen som står eller plukk selv om du ønsker noe spesielt)

Cirka frem til punktet "Lag et eget domene" kan du finne et løsningsforslag i repoet https://github.com/kleivane/immutable-webapp/ under mappene `terraform/test`, `terraform/prod` og `terraform/common`.

* Lag et prodmiljø
* La terraform opprette en [iam-bruker](https://www.terraform.io/docs/providers/aws/r/iam_user.html) som bruker av github med rettigheter kun til opplasting i buckets. [Rettighetssimulatoren](http://awspolicygen.s3.amazonaws.com/policygen.html) for iam kan hjelpe litt
* Ta i bruk remote [backend i S3 ](https://www.terraform.io/docs/backends/types/s3.html)
* Trekk ut til en felles terraform-modul
* Trekk ut bygging av index.html til en lambda
    * Lambdaen trenger kildekode i egen bucket
    * La tagging i github `lambda-x.y.z` trigge bygging og release av ny kildekode
    * Provisjoner lambda med terraform pr miljø og send inn versjon av kildekoden som skal brukes
* Lag et eget domene i Route 53 slik at du har en egen url
    * Lag sertifikat fra certification manager
    * Legg inn alias og sertifikat (`viewer_certificate`) i cloudfront. Merk av `ssl_support_method = sni-only` for å unngå ekstra kostnader!
    * Opprett alias i route53 med en ny [record](https://www.terraform.io/docs/providers/aws/r/route53_record.html)
    * *Alias record typically have a type of A or AAAA, but they work like a CNAME record*
* Ta i bruk https://github.com/nektos/act for kjøring av github-actions lokalt
* Skriv tester! https://terratest.gruntwork.io/
* Trekk ut prodmiljø i en egen AWS-account
* Rull ut dockercontaineren fra https://github.com/kleivane/static-json
* Test ut [workspaces](https://www.terraform.io/docs/state/workspaces.html) for terraform-endringer
* Bruk moduler fra https://github.com/cloudposse/, feks https://github.com/cloudposse/terraform-aws-cloudfront-cdn
* Flytt cachecontrol fra hver enkelt fil til lambda@edge
* Bruk en annen skyprovider


# Notater


## Lage Starterpack

* Klone repoet git clone <ssh> starterpack
* Slett .git-mappa
* Slett stuff under terraform (behold test/main og test/output og test/policy)
* Slett stuff under .github (behold nodejs0.yml, og triggere xxxxx)
* Lag et nytt repo på github
* Slett notatene her
* Kjør git init, add, commit, push til nytt repo

# TODOs til 7. main

* Fikse mer opplegg til Cloudfront-sjekk
* Lage starterpack

## Vurderinger
* Ta i bruk act for å enklere kjøring av github-action
* Trenger /build å lastes opp med sha i navnet?


## Gode sky-prinsipper
* Infrastruktur som kode
* Deploy av kode og infrastruktur skal skje fra ci
* Utviklere skal ha rettigheter som ikke stopper dem fra å teste og utforske
* Prod skal ha annen tilgangsstyring enn test
* Bygget kode skal kunne deployes til alle miljøer - config skal leve et annet sted
* Den eneste hemmeligheten utenfor infrastrukturen skal egentlig være access-keys
* Gjør deg kjent med verktøyene i skyplattformen, deres styrker og svakheter, følg med på nyheter :)
* Om to produkter kan løse samme oppgaven, velg den som gir minst vedlikeholdsarbeide

## Naming i terraform

name på ressursser = tf-*
navn i terraform   = se link

Tags
managed_by = terraform
environment = ci/dev/test/prod/common
system = tilhørighet


I alle moduler:
Lag en input variabel i alle moduler som heter `tags  , type map(string)`  og så ha en `tags = var.tags` eller vtags = merge(var.tags, { Name = "mytag"})   hvis du trenger å legge til egne
> Det aller viktigste er egentlig at du skriver moduler som du kan sende tags inn i uten å måtte endre hele modulen hvis du senere kommer på en tag som er kjekk å ha

iam:
type   = program/person

## Spørsmål?
- hvorfor trenger vi public acl på cp når man setter bucket til public? -> det virker som om canned acl tilhører et gammelt oppsett på aws s2 før iam-policies var lansert. Anbefalingene jeg har funnet frem preferer bucket
policies over acl. Sistnevnte må også settes både på bucket og på objektnivå, noe som er ganske forvirrende.
- kan man sette cachecontrol på bucketnivå?
