I [public_bucket.json.tpl](public_bucket.json.tpl) er et eksempel på en tamplatefil
for en iam-policy.

Følgende forklarer litt om inneholdet i fila

- Linje 2-6 er bolierplate
- Effect er enten Allow eller Deny. Her bruker vi allow for å tillate public acess
- Principal `*` dekker alle brukere, også uinloggede
- Action `"s3:GetObject"` er handlingen vil tillater, nemlig å lese en enkelt fil
- Resource er hvilken ressurss i AWS policyreglen gjelder til. Her spesifierer vil at det  gjelder `${bucket_arn}/*`, det vil si alle filer i bucketen med arn'en vi sender inn
