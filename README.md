# Vert.x Web App as Native Image with GraalVM

This is a basic test project which uses [GraalVM](https://www.graalvm.org/) / [Substrate VM](https://github.com/oracle/graal/tree/master/substratevm) VM to build a native image of a Vert.x Web application.

## Build/Reproduce

Build the app as usual (For this you need to have the GraalVM installed locally. Its not more than downloading and unpacking a tar)
```bash
./mvnw clean package
```

Collect reflection configurations (by triggering code paths i.e visit http://localhost:8080)
**Note:** the reflection configurations are saved when the process is stopped.
```bash
/path/to/graalvm/bin/java \
-agentlib:native-image-agent=config-output-dir=src/main/resources/META-INF/native-image/reflect-config \
-jar target/vertx-web-native-0.0.1-SNAPSHOT-fat.jar
```

Build the app again so the reflection configurations are included in the uber jar
**Note**: Other configuration parameters can either be added directly as CLI flag 
to the native-image command in the `Dockerfile` or to the `native-image.properties`.
```bash
./mvnw clean package
```

Build the app as a native image and run it
```bash
docker build -t local/vertx-web-native .
docker run -it --rm --name vertx-web-native -p 8080:8080 local/vertx-web-native
```
