// In src-tauri/src/commands.rs

use image::{GenericImage, GenericImageView, Rgba};
use imageproc::drawing::draw_text_mut;
use rusttype::{Font, Scale};
use std::path::PathBuf;
use std::time::{SystemTime, UNIX_EPOCH};

// Helper function to generate a unique output path
fn get_output_path(input_path: &str, suffix: &str) -> Result<String, String> {
    let path = PathBuf::from(input_path);
    let stem = path.file_stem().ok_or("Invalid file name")?.to_str().ok_or("Invalid file name")?;
    let extension = path.extension().ok_or("No extension")?.to_str().ok_or("Invalid extension")?;
    
    // Create a unique filename to avoid overwriting
    let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).map_err(|e| e.to_string())?.as_millis();
    let new_filename = format!("{}_{}_{}.{}", stem, suffix, timestamp, extension);

    // Save to the user's "Downloads" directory
    let downloads_dir = tauri::api::path::download_dir().ok_or("Could not find Downloads directory")?;
    let output_path = downloads_dir.join(new_filename);
    
    Ok(output_path.to_str().ok_or("Invalid output path")?.to_string())
}

#[tauri::command]
pub fn apply_grayscale(image_path: String) -> Result<String, String> {
    let mut img = image::open(&image_path).map_err(|e| e.to_string())?;
    img = img.grayscale();

    let output_path = get_output_path(&image_path, "grayscale")?;
    img.save(&output_path).map_err(|e| e.to_string())?;

    Ok(output_path)
}

#[tauri::command]
pub fn add_watermark(image_path: String, watermark_text: String) -> Result<String, String> {
    let mut img = image::open(&image_path).map_err(|e| e.to_string())?;

    // Load the font data from the bundled asset
    let font_data: &[u8] = include_bytes!("../assets/fonts/Roboto-VariableFont_wdth,wght.ttf");
    let font: Font<'static> = Font::try_from_bytes(font_data).ok_or("Failed to load font")?;

    let height = img.height() as f32;
    let scale = Scale {
        x: height * 0.1, // Scale font size based on image height
        y: height * 0.1,
    };

    let text_color = Rgba([255u8, 255u8, 255u8, 128u8]); // White with 50% opacity

    // Position the text at the bottom right
    let x_pos = (img.width() as f32 * 0.95) as i32;
    let y_pos = (img.height() as f32 * 0.95) as i32;

    draw_text_mut(&mut img, text_color, x_pos, y_pos, scale, &font, &watermark_text);

    let output_path = get_output_path(&image_path, "watermarked")?;
    img.save(&output_path).map_err(|e| e.to_string())?;

    Ok(output_path)
}