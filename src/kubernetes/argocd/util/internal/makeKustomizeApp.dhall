let TypesUnion = ../../TypesUnion.dhall

let Application = ../../Application/package.dhall

let ApplicationSpec = ../../ApplicationSpec/package.dhall

let SourceSpec = ../../SourceSpec/package.dhall

let KustomizeSourceSpec = ../../KustomizeSourceSpec/package.dhall

let KustomizeSpec = ../../KustomizeSpec/package.dhall

let k8s = ../../../k8s/package.dhall

in      \(appConfig : ../KustomizeAppConfig/Type.dhall)
    ->    TypesUnion.Application
            Application::{
            , metadata = k8s.schemas.ObjectMeta::{ name = appConfig.name }
            , spec =
                ApplicationSpec::{
                , project = appConfig.project
                , source =
                    SourceSpec.TypesUnion.Kustomize
                      KustomizeSourceSpec::{
                      , repoURL = appConfig.source.url
                      , path = appConfig.source.path
                      , targetRevision = appConfig.source.targetRevision
                      , kustomize =
                          KustomizeSpec::{
                          , commonLabels = appConfig.commonLabels
                          , images = appConfig.images
                          , namePrefix = appConfig.namePrefix
                          }
                      }
                , destination = appConfig.destination
                , syncPolicy = appConfig.syncPolicy
                , ignoreDifferences = Some appConfig.ignoreDifferences
                }
            }
        : TypesUnion