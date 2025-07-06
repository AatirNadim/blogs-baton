# React + Rust WebAssembly Image Processor

A modern web application that demonstrates the integration of **React** with **Rust** compiled to **WebAssembly (WASM)** for high-performance image processing operations.

## 🚀 Features

- **Image Upload & Display**: Upload images directly from your device
- **Grayscale Filter**: Apply grayscale effect using Rust/WASM for optimal performance
- **Watermark Function**: Demonstrate string passing between JavaScript and Rust
- **Real-time Processing**: Process images in the browser without server round-trips

## 🏗️ Project Structure

```text
wasm-util/
├── my-app/                    # React frontend application
│   ├── src/
│   │   ├── App.jsx           # Main React component with WASM integration
│   │   ├── App.css           # Styling
│   │   ├── main.jsx          # React entry point
│   │   └── pkg/              # Generated WASM bindings
│   │       ├── wasm_util.js  # JavaScript bindings
│   │       ├── wasm_util.d.ts # TypeScript definitions
│   │       └── wasm_util_bg.wasm # Compiled WebAssembly binary
│   ├── package.json          # Node.js dependencies
│   ├── vite.config.js        # Vite configuration
│   └── index.html            # HTML entry point
│
└── rust-lib/                 # Rust library for WASM
    ├── src/
    │   └── lib.rs            # Rust image processing functions
    ├── Cargo.toml            # Rust dependencies and configuration
    └── Cargo.lock            # Dependency lock file
```

## 🛠️ Technology Stack

### Frontend

- **React 19**: Modern React with latest features
- **Vite**: Fast build tool and development server
- **HTML5 Canvas**: For image manipulation and display
- **ESLint**: Code linting and formatting

### Backend (WASM)

- **Rust**: Systems programming language for performance
- **wasm-bindgen**: Rust/WASM ↔ JavaScript interop
- **web-sys**: Web API bindings for Rust

## 🔧 Installation & Setup

### Prerequisites

- Node.js (v16 or higher)
- Rust (latest stable version)
- pnpm (or npm/yarn)
- wasm-pack (for building Rust to WASM)

### Install wasm-pack

```bash
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
```

### Build the Rust Library

```bash
# Navigate to the Rust library directory
cd rust-lib

# Build the Rust code to WebAssembly
wasm-pack build --target web --out-dir ../my-app/src/pkg
```

### Install Frontend Dependencies

```bash
# Navigate to the React app directory
cd my-app

# Install dependencies
pnpm install
```

## 🚀 Running the Application

### Development Mode

```bash
# From the my-app directory
pnpm dev
```

The application will be available at `http://localhost:5173`

### Production Build

```bash
# Build for production
pnpm build

# Preview the production build
pnpm preview
```

## 💻 Usage

1. **Start the Application**: Run `pnpm dev` and open your browser
2. **Upload an Image**: Click "Choose File" and select an image from your device
3. **Apply Filters**:
   - **Grayscale**: Click "Apply Grayscale (WASM)" to convert the image to grayscale
   - **Watermark**: Click "Apply Watermark (WASM)" to see console logging (placeholder feature)
4. **Reset**: Click "Reset Image" to restore the original image

## 🔍 How It Works

### WASM Integration

The application demonstrates seamless integration between JavaScript and Rust:

1. **Rust Functions**: Image processing algorithms written in Rust for performance
2. **wasm-bindgen**: Generates JavaScript bindings for Rust functions
3. **React Integration**: React components call WASM functions directly
4. **Memory Management**: Efficient data transfer between JS and WASM memory spaces

### Image Processing Pipeline

1. User uploads an image file
2. Image is drawn on HTML5 Canvas
3. Canvas pixel data is extracted as `Uint8ClampedArray`
4. Data is passed to Rust/WASM function
5. Rust processes the image data
6. Processed data is returned and displayed on canvas

## 🧩 Core Functions

### Rust Functions (`rust-lib/src/lib.rs`)

- `apply_grayscale(image_data: &[u8]) -> Vec<u8>`: Converts image to grayscale
- `apply_watermark(image_data: &[u8], text: &str) -> Vec<u8>`: Watermark functionality (demo)

### React Integration (`my-app/src/App.jsx`)

- WASM module initialization
- File upload handling
- Canvas manipulation
- Function calls to Rust/WASM

## 🎯 Benefits of This Architecture

- **Performance**: Rust provides near-native performance for computationally intensive tasks
- **Memory Safety**: Rust's ownership system prevents common programming errors
- **Web Compatibility**: WASM runs in all modern browsers
- **Developer Experience**: Maintain familiar React development workflow
- **Code Reuse**: Rust logic can be shared across platforms

## 🔗 Useful Resources

- [wasm-bindgen Documentation](https://rustwasm.github.io/wasm-bindgen/)
- [Rust and WebAssembly](https://rustwasm.github.io/docs/book/)
- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)