
use actix_web::{web, App, HttpServer, Responder, HttpResponse};
use serde::Deserialize;
use dashmap::DashMap; // A HashMap that can be safely shared across threads
use std::sync::Arc;


// Define the structure of the incoming JSON request
#[derive(Deserialize)]
struct WordCountRequest {
    text: String,
}

// The core logic function that processes the text
// It's marked `async` because Actix Web is an async framework
async fn count_words(req: web::Json<WordCountRequest>) -> impl Responder {
    let text = req.into_inner().text;
    // Arc (Atomic Reference Counter) allows us to safely share the DashMap
    // with multiple threads (or in this async context, multiple tasks).
    let word_counts = Arc::new(DashMap::new());

    // --- Concurrent Processing ---
    // We split the text by whitespace and process chunks concurrently.
    // In a real high-performance app, you might use a thread pool like Rayon.
    // Here, we'll use a simple parallel iteration over words.
    let words: Vec<_> = text.split_whitespace().map(str::to_lowercase).collect();

    for word in words {
        // DashMap allows us to increment the count from multiple threads/tasks safely,
        // without needing manual locks. It handles the synchronization internally.
        *word_counts.entry(word).or_insert(0) += 1;
    }

    // Convert the DashMap to a regular HashMap for JSON serialization
    let result: std::collections::HashMap<_, _> = word_counts
        .iter()
        .map(|entry| (entry.key().clone(), *entry.value()))
        .collect();

    HttpResponse::Ok().json(result)
}


async fn health_check() -> impl Responder {
    HttpResponse::Ok().body("OK")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("Starting server on http://127.0.0.1:8080");
    HttpServer::new(|| {
        // add new route for health check
        App::new().route("/wordcount", web::get().to(count_words))
        // You can add more routes here as needed
        // For example, a health check endpoint
        .route("/", web::get().to(health_check))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
