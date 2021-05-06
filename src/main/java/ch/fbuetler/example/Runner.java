package ch.fbuetler.example;

import io.vertx.core.Vertx;
import io.vertx.ext.web.Router;

public class Runner {

	public static void main(String[] args) {
		System.out.println("Starting server...");

		Vertx vertx = Vertx.vertx();
		Router router = Router.router(vertx);

		router.route().handler(rc -> {
			rc.response().end("Hello world!");
		});

		vertx.createHttpServer().requestHandler(router::handle).listen(8080);

		System.out.println("Listening on: http://localhost:8080");
	}

}
