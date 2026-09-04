# talay-gitops

Argo CD'yi kurar ve tek bir root `ApplicationSet` ile `talay-environments` içindeki bütün uygulama tanımlarını izletir. Terraform Argo CD'nin kendisini ve bootstrap nesnesini yönetir; uygulama Deployment/Service/Ingress nesnelerini Argo CD yönetir.

State Git'te değildir: Terraform state `terraform-states` namespace'indeki Kubernetes Secret'ındadır, Argo CD'nin canlı cache/çalışma durumu cluster'dadır, uygulamaların istenen durumu ise `talay-environments` Git reposundadır. Sunucu kaybolduğunda cluster bootstrap state'i ve şifreli Kubernetes state yedeği kullanılarak cluster yeniden kurulup bu repo bootstrap edilir; Argo CD desired state'i tekrar uygular.

OIDC isteğe bağlıdır ve geçici operasyon görünürlüğü için varsayılan olarak kapalıdır; Dex de kurulmaz. `oidc_enabled=true` yapıldığında Keycloak public PKCE istemcisi `talay-argocd` kullanılır ve `talay-platform-admins` grubu Argo CD admin rolüne eşlenir. Yerel admin açık kalır; OIDC testinden sonra `configs.cm.admin.enabled=false` yapılmalıdır.
