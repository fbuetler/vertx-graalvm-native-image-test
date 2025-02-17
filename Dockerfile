FROM ghcr.io/graalvm/graalvm-ce:java11-21.1.0 AS buildEnv
RUN gu install native-image

WORKDIR /workdir
COPY target/vertx-web-native-0.0.1-SNAPSHOT-fat.jar ./vertx-web-native.jar
RUN native-image \
    --no-server \
    --no-fallback \
    --allow-incomplete-classpath \
    --initialize-at-run-time=io.netty.handler.codec.http.HttpObjectEncoder \
    --initialize-at-run-time=io.netty.handler.codec.http.websocketx.WebSocket00FrameEncoder \
    --initialize-at-run-time=io.netty.handler.codec.http2.Http2CodecUtil \
    --initialize-at-run-time=io.netty.handler.codec.http2.DefaultHttp2FrameWriter \
    --initialize-at-run-time=io.netty.handler.ssl.ReferenceCountedOpenSslEngine \
    --initialize-at-run-time=io.netty.handler.ssl.OpenSslSessionContext \
    --initialize-at-run-time=io.netty.handler.ssl.ReferenceCountedOpenSslContext \
    --initialize-at-run-time=io.netty.handler.ssl.JdkNpnApplicationProtocolNegotiator \
    --initialize-at-run-time=io.netty.handler.ssl.ConscryptAlpnSslEngine \
    --initialize-at-run-time=io.netty.handler.ssl.JettyAlpnSslEngine$ClientEngine \
    --initialize-at-run-time=io.netty.handler.ssl.JettyAlpnSslEngine$ServerEngine \
    --initialize-at-run-time=io.netty.util.internal.logging.Log4JLogger \
    --initialize-at-run-time=io.netty.handler.ssl.JettyNpnSslEngine \
    -H:+ReportExceptionStackTraces \
    -H:+ReportUnsupportedElementsAtRuntime \
    -Dio.netty.noUnsafe=true \
    -Dfile.encoding=UTF-8 \
    -jar vertx-web-native.jar

FROM debian:buster-slim 
COPY --from=buildEnv /workdir/vertx-web-native vertx-web-native
CMD ["/vertx-web-native"]

