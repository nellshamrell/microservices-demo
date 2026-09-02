extension radius

param environment string

@description('Username for the OCI registry the containerImages recipe pushes to.')
param registryUsername string

@description('Password/token for the OCI registry the containerImages recipe pushes to.')
@secure()
param registryPassword string

resource microservicesDemoApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'microservices-demo'
  properties: {
    environment: environment
  }
}

resource redisCache 'Radius.Data/redisCaches@2025-08-01-preview' = {
  name: 'redis'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'kustomize/base/cartservice.yaml#L89'
    size: 'S'
  }
}

resource registryCreds 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'radius-ghcr-registry-creds'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: '.radius/app.bicep'
    data: {
      password: {
        value: registryPassword
      }
      username: {
        value: registryUsername
      }
    }
    kind: 'basicAuthentication'
  }
}

resource adserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'adservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/adservice/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/adservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource cartserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'cartservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/cartservice/src/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/cartservice/src?ref=72390a864b26690cc322736577044e7bd07be581'
    }
    tag: '72390a8'
  }
  dependsOn: [
    registryCreds
  ]
}

resource checkoutserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'checkoutservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/checkoutservice/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/checkoutservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource currencyserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'currencyservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/currencyservice/Dockerfile'
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/currencyservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource emailserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'emailservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/emailservice/Dockerfile'
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/emailservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource frontendImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'frontend-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/frontend/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/frontend?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource loadgeneratorImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'loadgenerator-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/loadgenerator/Dockerfile'
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/loadgenerator?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource paymentserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'paymentservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/paymentservice/Dockerfile'
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/paymentservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource productcatalogserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'productcatalogservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/productcatalogservice/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/productcatalogservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource recommendationserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'recommendationservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/recommendationservice/Dockerfile'
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/recommendationservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource shippingserviceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'shippingservice-image'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/shippingservice/Dockerfile'
    build: {
      source: 'git::https://github.com/nellshamrell/microservices-demo.git//src/shippingservice?ref=72ba613a05f7fcee51cf1d0badff401b6ae7074d'
    }
    tag: '72ba613'
  }
  dependsOn: [
    registryCreds
  ]
}

resource adserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'adservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/adservice/src/main/java/hipstershop/AdService.java#L223'
    containers: {
      adservice: {
        image: adserviceImage.properties.imageReference
        env: {
          PORT: {
            value: '9555'
          }
        }
        ports: {
          grpc: {
            containerPort: 9555
          }
        }
      }
    }
  }
}

resource cartserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'cartservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/cartservice/src/Program.cs'
    containers: {
      cartservice: {
        image: cartserviceImage.properties.imageReference
        env: {
          REDIS_ADDR: {
            valueFrom: {
              secretKeyRef: {
                key: 'url'
                secretName: redisCache.properties.secrets.name
              }
            }
          }
        }
        ports: {
          grpc: {
            containerPort: 7070
          }
        }
      }
    }
  }
}

resource currencyserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'currencyservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/currencyservice/server.js#L193'
    containers: {
      currencyservice: {
        image: currencyserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '7000'
          }
        }
        ports: {
          grpc: {
            containerPort: 7000
          }
        }
      }
    }
  }
}

resource emailserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'emailservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/emailservice/email_server.py#L166'
    containers: {
      emailservice: {
        image: emailserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '8080'
          }
        }
        ports: {
          grpc: {
            containerPort: 8080
          }
        }
      }
    }
  }
}

resource paymentserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'paymentservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/paymentservice/index.js#L70'
    containers: {
      paymentservice: {
        image: paymentserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '50051'
          }
        }
        ports: {
          grpc: {
            containerPort: 50051
          }
        }
      }
    }
  }
}

resource productcatalogserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'productcatalogservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/productcatalogservice/server.go#L68'
    containers: {
      productcatalogservice: {
        image: productcatalogserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '3550'
          }
        }
        ports: {
          grpc: {
            containerPort: 3550
          }
        }
      }
    }
  }
}

resource shippingserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'shippingservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/shippingservice/main.go#L56'
    containers: {
      shippingservice: {
        image: shippingserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '50051'
          }
        }
        ports: {
          grpc: {
            containerPort: 50051
          }
        }
      }
    }
  }
}

resource checkoutserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'checkoutservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/checkoutservice/main.go#L88'
    containers: {
      checkoutservice: {
        image: checkoutserviceImage.properties.imageReference
        env: {
          CART_SERVICE_ADDR: {
            value: '${cartserviceContainer.properties.hosts['cartservice']}:7070'
          }
          CURRENCY_SERVICE_ADDR: {
            value: '${currencyserviceContainer.properties.hosts['currencyservice']}:7000'
          }
          EMAIL_SERVICE_ADDR: {
            value: '${emailserviceContainer.properties.hosts['emailservice']}:8080'
          }
          PAYMENT_SERVICE_ADDR: {
            value: '${paymentserviceContainer.properties.hosts['paymentservice']}:50051'
          }
          PORT: {
            value: '5050'
          }
          PRODUCT_CATALOG_SERVICE_ADDR: {
            value: '${productcatalogserviceContainer.properties.hosts['productcatalogservice']}:3550'
          }
          SHIPPING_SERVICE_ADDR: {
            value: '${shippingserviceContainer.properties.hosts['shippingservice']}:50051'
          }
        }
        ports: {
          grpc: {
            containerPort: 5050
          }
        }
      }
    }
  }
}

resource recommendationserviceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'recommendationservice'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/recommendationservice/recommendation_server.py#L97'
    containers: {
      recommendationservice: {
        image: recommendationserviceImage.properties.imageReference
        env: {
          DISABLE_PROFILER: {
            value: '1'
          }
          PORT: {
            value: '8080'
          }
          PRODUCT_CATALOG_SERVICE_ADDR: {
            value: '${productcatalogserviceContainer.properties.hosts['productcatalogservice']}:3550'
          }
        }
        ports: {
          grpc: {
            containerPort: 8080
          }
        }
      }
    }
  }
}

resource frontendContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/frontend/main.go#L91'
    containers: {
      frontend: {
        image: frontendImage.properties.imageReference
        env: {
          AD_SERVICE_ADDR: {
            value: '${adserviceContainer.properties.hosts['adservice']}:9555'
          }
          CART_SERVICE_ADDR: {
            value: '${cartserviceContainer.properties.hosts['cartservice']}:7070'
          }
          CHECKOUT_SERVICE_ADDR: {
            value: '${checkoutserviceContainer.properties.hosts['checkoutservice']}:5050'
          }
          CURRENCY_SERVICE_ADDR: {
            value: '${currencyserviceContainer.properties.hosts['currencyservice']}:7000'
          }
          ENABLE_PROFILER: {
            value: '0'
          }
          PORT: {
            value: '8080'
          }
          PRODUCT_CATALOG_SERVICE_ADDR: {
            value: '${productcatalogserviceContainer.properties.hosts['productcatalogservice']}:3550'
          }
          RECOMMENDATION_SERVICE_ADDR: {
            value: '${recommendationserviceContainer.properties.hosts['recommendationservice']}:8080'
          }
          SHIPPING_SERVICE_ADDR: {
            value: '${shippingserviceContainer.properties.hosts['shippingservice']}:50051'
          }
          SHOPPING_ASSISTANT_SERVICE_ADDR: {
            value: 'shoppingassistantservice:80'
          }
        }
        ports: {
          web: {
            containerPort: 8080
          }
        }
      }
    }
  }
}

resource loadgeneratorContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'loadgenerator'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'src/loadgenerator/locustfile.py'
    containers: {
      frontendCheck: {
        image: 'busybox:1.38.0@sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d'
        args: [
          '-exc'
          'MAX_RETRIES=12; RETRY_INTERVAL=10; for i in $(seq 1 $MAX_RETRIES); do echo "Attempt $i: Pinging frontend: \${FRONTEND_ADDR}..."; STATUSCODE=$(wget --server-response http://\${FRONTEND_ADDR} 2>&1 | awk \'/^  HTTP/{print $2}\'); if [ "$STATUSCODE" -eq 200 ]; then echo "Frontend is reachable."; exit 0; fi; echo "Error: Could not reach frontend - Status code: \${STATUSCODE}"; sleep $RETRY_INTERVAL; done; echo "Failed to reach frontend after $MAX_RETRIES attempts."; exit 1'
        ]
        command: [
          '/bin/sh'
        ]
        env: {
          FRONTEND_ADDR: {
            value: '${frontendContainer.properties.hosts['frontend']}:8080'
          }
        }
        initContainer: true
      }
      loadgenerator: {
        image: loadgeneratorImage.properties.imageReference
        env: {
          FRONTEND_ADDR: {
            value: '${frontendContainer.properties.hosts['frontend']}:8080'
          }
          RATE: {
            value: '1'
          }
          USERS: {
            value: '10'
          }
        }
      }
    }
    replicas: 1
    restartPolicy: 'Always'
  }
}

resource frontendRoute 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'frontend-route'
  properties: {
    environment: environment
    application: microservicesDemoApp.id
    codeReference: 'kustomize/base/frontend.yaml#L124'
    kind: 'HTTP'
    rules: [
      {
        destinationContainer: {
          resourceId: frontendContainer.id
          containerName: 'frontend'
          containerPort: 8080
        }
        matches: [
          {
            httpPath: '/'
          }
        ]
      }
    ]
  }
}
