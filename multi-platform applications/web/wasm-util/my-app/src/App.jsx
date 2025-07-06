import React, { useState, useEffect, useRef } from "react";
import "./App.css";

// 1. Import the Wasm module and its initializer
import init, { apply_grayscale, apply_watermark } from "./pkg/wasm_util.js";

function App() {
  const [isWasmLoaded, setWasmLoaded] = useState(false);
  const [originalImage, setOriginalImage] = useState(null);
  const canvasRef = useRef(null);

  // 2. Initialize the Wasm module ONCE on component mount
  useEffect(() => {
    const loadWasm = async () => {
      try {
        await init(); // This loads the .wasm file
        setWasmLoaded(true);
        console.log("Wasm module loaded successfully.");
      } catch (error) {
        console.error("Error loading Wasm module:", error);
      }
    };
    loadWasm();
  }, []); // Empty dependency array ensures this runs only once

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          setOriginalImage(img);
          drawImageOnCanvas(img);
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  };

  const drawImageOnCanvas = (img) => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");
    canvas.width = img.width;
    canvas.height = img.height;
    ctx.drawImage(img, 0, 0);
  };

  // 3. Define the function to call the Wasm grayscale filter
  const applyGrayscaleFilter = () => {
    if (!originalImage) return;

    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");
    // Get the raw pixel data from the canvas
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    // Call the Wasm function!
    const processedData = apply_grayscale(imageData.data);

    // Put the processed data back onto the canvas
    const newImageData = new ImageData(
      new Uint8ClampedArray(processedData),
      canvas.width,
      canvas.height
    );
    ctx.putImageData(newImageData, 0, 0);
  };

  // 4. Define the function to call the Wasm watermark function
  const applyWatermarkFilter = () => {
    if (!originalImage) return;
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    // Call the Wasm function with a string argument
    apply_watermark(imageData.data, "Hello from React!");

    // Note: The Rust function currently just logs to the console
    // and returns the original data. No visual change will happen.
    console.log("Check the browser console for the message from Wasm.");
  };

  const resetImage = () => {
    if (originalImage) {
      drawImageOnCanvas(originalImage);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>React + Rust (Wasm) Image Processor</h1>
        <p>
          Wasm Status:{" "}
          {isWasmLoaded ? (
            <span style={{ color: "green", fontWeight: "bold" }}>Loaded!</span>
          ) : (
            <span style={{ color: "yellow", fontWeight: "bold" }}>
              Loading...
            </span>
          )}
        </p>
        <input type="file" accept="image/*" onChange={handleImageUpload} />

        <div className="controls">
          <button
            onClick={applyGrayscaleFilter}
            disabled={!isWasmLoaded || !originalImage}
            className="wasm-button"
          >
            Apply Grayscale (Wasm)
          </button>
          <button
            onClick={applyWatermarkFilter}
            disabled={!isWasmLoaded || !originalImage}
            className="wasm-button"
          >
            Apply Watermark (Wasm)
          </button>
          <button
            onClick={resetImage}
            disabled={!originalImage}
            className="wasm-button"
          >
            Reset Image
          </button>
        </div>

        <canvas
          ref={canvasRef}
          style={{ marginTop: "20px", maxWidth: "100%" }}
        />
      </header>
    </div>
  );
}

export default App;
