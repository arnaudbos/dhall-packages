{-
    Utility to add sync waves to argocd applications and projects.
-}
let k8s =
        ../../k8s/1.14.dhall sha256:7839bf40f940757e4d71d3c1b84d878f6a4873c3b2706ae4be307b5991acdcac
      ? ../../k8s/1.14.dhall

let Project =
        ../Project/package.dhall sha256:43e36b1dc0eec92d602643cbee9b21bf5d27b8912cabf8d88a1776b5a5b1f7d8
      ? ../Project/package.dhall

let Application =
        ../Application/package.dhall sha256:36ddc602d37556fed812b098dbd6efc22062e68418d6b6d2ce8a1f3ff9118067
      ? ../Application/package.dhall

let TypesUnion =
        ../TypesUnion.dhall sha256:e1ec4a7e47e1182ee7f7308ddd397bfec0ebe4da9188f1a85ff7f062a68b9b71
      ? ../TypesUnion.dhall

let withSyncWaveMetadata =
          \(wave : Integer)
      ->  \(metadata : k8s.ObjectMeta.Type)
      ->      metadata
          //  { annotations =
                    metadata.annotations
                  # toMap { `argocd.argoproj.io/sync-wave` = Integer/show wave }
              }

let withSyncWaveApplication =
          \(wave : Integer)
      ->  \(app : Application.Type)
      ->  TypesUnion.Application
            (app // { metadata = withSyncWaveMetadata wave app.metadata })

let withSyncWaveProject =
          \(wave : Integer)
      ->  \(proj : Project.Type)
      ->  TypesUnion.Project
            (proj // { metadata = withSyncWaveMetadata wave proj.metadata })

in      \(wave : Integer)
    ->  \(argocdUnion : TypesUnion)
    ->  merge
          { Application = withSyncWaveApplication wave
          , Project = withSyncWaveProject wave
          }
          argocdUnion
