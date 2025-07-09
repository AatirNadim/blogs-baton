use image::{GenericImage, GenericImageView, Rgba};
use imageproc::drawing::draw_text_mut;
use rusttype::{Font, Scale};
use std::path::PathBuf;
use std::time::{SystemTime, UNIX_EPOCH};
use tauri::command;

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .invoke_handler(tauri::generate_handler![apply_grayscale, add_watermark])
        .run(tauri::generate_context!())
        .expect("error while running  tauri application");
}

fn get_output_path(input_path: &str, suffix: &str) -> Result<String, String> {
    let path = PathBuf::from(input_path);
    let stem = path
        .file_stem()
        .ok_or("Invalid file name")?
        .to_str()
        .ok_or("Invalid file name")?;
    let extension = path
        .extension()
        .ok_or("No extension")?
        .to_str()
        .ok_or("Invalid extension")?;

    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map_err(|e| e.to_string())?
        .as_millis();
    let new_filename = format!("{}_{}_{}.{}", stem, suffix, timestamp, extension);

    // THIS IS THE DIRS CRATE WAY:
    // The `dirs::download_dir()` function returns an `Option<PathBuf>`.
    // We convert the `None` case into an `Err` to fit our function's return type.
    let downloads_dir =
        dirs::download_dir().ok_or("Could not find the user's Downloads directory")?;

    let output_path = downloads_dir.join(new_filename);

    Ok(output_path
        .to_str()
        .ok_or("Invalid output path")?
        .to_string())
}

#[command]
fn apply_grayscale(image_path: String) -> Result<String, String> {
    let mut img = image::open(&image_path).map_err(|e| e.to_string())?;
    img = img.grayscale();

    let output_path = get_output_path(&image_path, "grayscale")?;
    img.save(&output_path).map_err(|e| e.to_string())?;

    Ok(output_path)
}

#[command]
fn add_watermark(image_path: String, watermark_text: String) -> Result<String, String> {
    let mut img = image::open(&image_path).map_err(|e| e.to_string())?;

    // Load the font data from the bundled asset
    let font_data: &[u8] = include_bytes!("../assets/fonts/Roboto-VariableFont_wdth,wght.ttf");
    let font: Font<'static> = Font::try_from_bytes(font_data).ok_or("Failed to load font")?;

    let height = img.height() as f32;
    let scale = Scale {
        x: height * 0.1,
        y: height * 0.1,
    };

    let text_color = Rgba([255u8, 255u8, 255u8, 128u8]);

    let x_pos = (img.width() as f32 * 0.95) as i32;
    let y_pos = (img.height() as f32 * 0.95) as i32;

    draw_text_mut(
        &mut img,
        text_color,
        x_pos,
        y_pos,
        scale,
        &font,
        &watermark_text,
    );

    let output_path = get_output_path(&image_path, "watermarked")?;
    img.save(&output_path).map_err(|e| e.to_string())?;

    Ok(output_path)
}
