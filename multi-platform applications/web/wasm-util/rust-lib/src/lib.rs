// Using wasm-bindgen to create the bridge to JavaScript
use wasm_bindgen::prelude::*;

// This is the function JavaScript will call to apply a grayscale filter.
// It takes a byte slice (our raw image data) and returns a new Vec<u8> (the processed data).

#[wasm_bindgen]
pub fn apply_grayscale(image_data: &[u8]) -> Vec<u8> {
    let mut processed_data = image_data.to_vec();
    // A simple grayscale algorithm: loop through pixels (4 bytes at a time: R,G,B,A)
    for pixel in processed_data.chunks_mut(4) {
        let gray = (pixel[0] as u32 + pixel[1] as u32 + pixel[2] as u32) / 3;
        pixel[0] = gray as u8; // Red
        pixel[1] = gray as u8; // Green
        pixel[2] = gray as u8; // Blue
        // pixel[3] is Alpha, we leave it untouched
    }
    processed_data
}

// A more complex function that shows passing a string from JS to Rust.
// This would be much more complex in reality (requiring a font-rendering library).
// For this example, we'll just log it to show it works.

#[wasm_bindgen]
pub fn apply_watermark(image_data: &[u8], text: &str) -> Vec<u8> {
    // In a real app, we'd use a library like 'rusttype' to draw the `text` onto the `image_data`.
    // For now, let's just prove we received the text.
    // The `web_sys::console::log_1` function lets our Rust/Wasm code log to the browser console.
    web_sys::console::log_1(&format!("Applying watermark: '{}'", text).into());

    // Just return the original image data for this simple example.
    image_data.to_vec()
}