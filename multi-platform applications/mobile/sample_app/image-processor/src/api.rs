// rust/native/src/api.rs
use image::{imageops, DynamicImage};

// This is a more idiomatic way to handle errors with the bridge
// The alias simplifies the function signatures
pub type anyhow_Result<T> = Result<T, anyhow::Error>;

/// Applies a greyscale filter to an image.
/// Takes raw image bytes and returns raw image bytes (PNG format).
pub fn apply_greyscale(image_bytes: Vec<u8>) -> anyhow_Result<Vec<u8>> {
    // 1. Load the image from the byte vector. The bridge handles the conversion.
    let img = image::load_from_memory(&image_bytes)?;

    // 2. Perform the operation
    let greyscale_img = img.grayscale();

    // 3. Encode the result back into a byte vector (PNG format)
    Ok(encode_image_to_png(greyscale_img)?)
}

/// Overlays a watermark onto a main image.
/// Takes two sets of raw image bytes and returns the result (PNG format).
pub fn apply_watermark(
    main_image_bytes: Vec<u8>,
    watermark_image_bytes: Vec<u8>,
) -> anyhow_Result<Vec<u8>> {
    let mut main_img = image::load_from_memory(&main_image_bytes)?;
    let watermark_img = image::load_from_memory(&watermark_image_bytes)?;

    // Calculate position for bottom-right corner
    let x_pos = main_img.width() as i64 - watermark_img.width() as i64;
    let y_pos = main_img.height() as i64 - watermark_img.height() as i64;

    // Overlay the watermark
    imageops::overlay(&mut main_img, &watermark_img, x_pos, y_pos);

    Ok(encode_image_to_png(main_img)?)
}

// Helper function to keep code DRY
fn encode_image_to_png(image: DynamicImage) -> anyhow_Result<Vec<u8>> {
    let mut buffer = Vec::new();
    image.write_to(
        &mut std::io::Cursor::new(&mut buffer),
        image::ImageOutputFormat::Png,
    )?;
    Ok(buffer)
}