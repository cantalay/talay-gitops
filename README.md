# talay-gitops

Argo CD'yi kurar ve tek bir root `ApplicationSet` ile `talay-environments` içindeki bütün uygulama tanımlarını izletir. Terraform Argo CD'nin kendisini ve bootstrap nesnesini yönetir; uygulama Deployment/Service/Ingress nesnelerini Argo CD yönetir.

State Git'te değildir: Terraform state harici S3 backend'dedir, Argo CD'nin canlı cache/çalışma durumu cluster'dadır, uygulamaların istenen durumu ise `talay-environments` Git reposundadır. Sunucu kaybolduğunda cluster yeniden kurulup bu repo bootstrap edildiğinde Argo CD desired state'i tekrar uygular.

OIDC Keycloak'a public PKCE istemcisi `talay-argocd` ile bağlanacak şekilde hazırlanmıştır. Realm grubu `talay-platform-admins`, Argo CD admin rolüne eşlenir. İlk doğrulama bitene kadar yerel admin açık kalır; OIDC testinden sonra `configs.cm.admin.enabled=false` yapılmalıdır.
