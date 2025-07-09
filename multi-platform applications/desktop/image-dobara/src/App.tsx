import { useState } from "react";
import { invoke } from "@tauri-apps/api/core";
import { open } from "@tauri-apps/plugin-dialog";
import { convertFileSrc } from "@tauri-apps/api/core"; 
import "./App.css";

function App() {
  const [selectedImagePath, setSelectedImagePath] = useState<string | null>(
    null
  );
  const [watermarkText, setWatermarkText] = useState<string>("Tauri Rocks!");
  const [processedImagePath, setProcessedImagePath] = useState<string | null>(
    null
  );

  const selectImage = async () => {
    // Reset previous results
    setProcessedImagePath(null);

    try {
      // The `open` function is now imported from the dialog plugin
      const result = await open({
        multiple: false,
        filters: [{ name: "Images", extensions: ["png", "jpeg", "jpg"] }],
      });

      // In v2, the `open` function directly returns the path as a string,
      // an array of strings, or null. No need to access a `.path` property.
      if (typeof result === "string") {
        setSelectedImagePath(result);
      } else {
        // User cancelled the dialog
        setSelectedImagePath(null);
      }
    } catch (error) {
      // This will catch errors if the plugin isn't configured correctly
      console.error("Error selecting image:", error);
      alert(`Error selecting image: ${error}`);
    }
  };

  const applyGrayscale = async () => {
    if (!selectedImagePath) {
      alert("Please select an image first!");
      return;
    }
    try {
      // `invoke` from `@tauri-apps/api/core` is correct
      const newPath = await invoke<string>("apply_grayscale", {
        imagePath: selectedImagePath,
      });
      setProcessedImagePath(newPath);
    } catch (error) {
      alert(`Error: ${error}`);
    }
  };

  const addWatermark = async () => {
    if (!selectedImagePath) {
      alert("Please select an image first!");
      return;
    }
    try {
      const newPath = await invoke<string>("add_watermark", {
        imagePath: selectedImagePath,
        watermarkText: watermarkText,
      });
      setProcessedImagePath(newPath);
    } catch (error) {
      alert(`Error: ${error}`);
    }
  };

  return (
    <div className="container">
      <h1>Image Processor (React)</h1>

      <div className="row">
        <button onClick={selectImage}>Select Image</button>
        {selectedImagePath && (
          <p className="label">
            Selected: <code>{selectedImagePath.split(/[/\\]/).pop()}</code>
          </p>
        )}
      </div>

      <div className="row">
        <label htmlFor="watermark">Watermark Text:</label>
        <input
          id="watermark"
          onChange={(e) => setWatermarkText(e.currentTarget.value)}
          value={watermarkText}
          placeholder="Enter watermark text..."
          disabled={!selectedImagePath}
        />
      </div>

      <div className="row">
        <button onClick={applyGrayscale} disabled={!selectedImagePath}>
          Apply Grayscale
        </button>
        <button onClick={addWatermark} disabled={!selectedImagePath}>
          Add Watermark
        </button>
      </div>

      {processedImagePath && (
        <div className="result-container">
          <h2>Result</h2>
          <p>
            Saved at: <code>{processedImagePath}</code>
          </p>
          <img
            // `convertFileSrc` now comes from `@tauri-apps/api/path`
            src={convertFileSrc(processedImagePath)}
            alt="Processed"
            className="result-image"
          />
        </div>
      )}
    </div>
  );
}

export default App;
