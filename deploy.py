#!/usr/bin/env python3
"""
Production deployment script for Railway/Render
Runs training pipeline then starts the UI application
"""
import subprocess
import sys
import os
from pathlib import Path

def main():
    # Set working directory to project root
    project_root = Path(__file__).parent
    os.chdir(project_root)
    
    print(" Starting deployment...")
    
    # Step 1: Train the model
    print(" Training ML model...")
    try:
        result = subprocess.run([sys.executable, "entrypoints/training.py"], 
                              check=True, capture_output=True, text=True)
        print("Model training completed successfully")
        print(result.stdout)  # Show training output
    except subprocess.CalledProcessError as e:
        print(f"Training failed: {e}")
        print(f"Error output: {e.stderr}")
        sys.exit(1)
    
    # Step 2: Start the UI application (this should not exit)
    print("Starting web application...")
    print("Web app will be available on port 8050")
    
    # Import and run the app directly instead of subprocess
    # This prevents the process from exiting
    try:
        # Add project paths
        sys.path.insert(0, str(project_root / "src"))
        
        # Import and run the app
        from app_ui.app import app
        
        # Get port from environment (Render sets this)
        port = int(os.environ.get("PORT", 8050))
        
        print(f"Starting server on port {port}...")
        app.run_server(debug=False, host="0.0.0.0", port=port)
        
    except Exception as e:
        print(f"UI startup failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()