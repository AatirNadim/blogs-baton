// In src/App.tsx

import { useState } from 'react';
import { invoke } from '@tauri-apps/api/tauri';
import { open } from '@tauri-apps/api/dialog';
import { convertFileSrc } from '@tauri-apps/api/path';
import './App.css';

function App() {
  const [selectedImagePath, setSelectedImagePath] = useState<string | null>(null);
  const [watermarkText, setWatermarkText] = useState<string>('Tauri Rocks!');
  const [processedImagePath, setProcessedImagePath] = useState<string | null>(null);

  const selectImage = async () => {
    // Reset previous results
    setProcessedImagePath(null);

    const result = await open({
      multiple: false,
      filters: [{ name: 'Images', extensions: ['png', 'jpeg', 'jpg'] }],
    });

    if (typeof result === 'string') {
      setSelectedImagePath(result);
    }
  };

  const applyGrayscale = async () => {
    if (!selectedImagePath) {
      alert('Please select an image first!');
      return;
    }
    try {
      const newPath = await invoke<string>('apply_grayscale', { imagePath: selectedImagePath });
      setProcessedImagePath(newPath);
    } catch (error) {
      alert(`Error: ${error}`);
    }
  };

  const addWatermark = async () => {
    if (!selectedImagePath) {
      alert('Please select an image first!');
      return;
    }
    try {
      const newPath = await invoke<string>('add_watermark', {
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
        {selectedImagePath && <p className="label">Selected: <code>{selectedImagePath.split(/[/\\]/).pop()}</code></p>}
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
          <p>Saved at: <code>{processedImagePath}</code></p>
          <img
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